class FirebaseIDTokenVerifier
  VALID_JWT_PUBLIC_KEYS_RESPONSE_CACHE_KEY = "firebase_phone_jwt_public_keys_cache_key".freeze
  JWT_ALGORITHM = "RS256".freeze

  def initialize(firebase_project_id)
    @firebase_project_id = firebase_project_id
  end

  def encode(rsa_private, user_id = nil, email = nil, name = nil)
    valid_public_keys = FirebaseIDTokenVerifier.retrieve_and_cache_jwt_valid_public_keys

    payload = { exp: Time.now.getutc.to_i + 60 * 60, iat: Time.now.getutc.to_i - 60 * 60,
                aud: @firebase_project_id, iss: "https://securetoken.google.com/" + @firebase_project_id,
                sub: user_id, user_id: user_id, email: email, name: name }
    kid = valid_public_keys.keys[0]
    headers = { alg: JWT_ALGORITHM, kid: kid }

    encoded_token = JWT.encode payload, rsa_private, JWT_ALGORITHM, headers

    encoded_token
  end

  def decode(id_token, public_key)
    decoded_token, error = FirebaseIDTokenVerifier.decode_jwt_token(id_token, @firebase_project_id, nil)
    raise error unless error.nil?

    # Decoded data example:
    # [
    #   {"data"=>"test"}, # payload
    #   {"typ"=>"JWT", "alg"=>"none"} # header
    # ]
    payload = decoded_token[0]
    headers = decoded_token[1]

    # validate headers

    alg = headers["alg"]
    raise "Invalid access token 'alg' header (#{alg}). Must be '#{JWT_ALGORITHM}'." if alg != JWT_ALGORITHM

    valid_public_keys = FirebaseIDTokenVerifier.retrieve_and_cache_jwt_valid_public_keys
    kid = headers["kid"]
    raise "Invalid access token 'kid' header, do not correspond to valid public keys." unless valid_public_keys.key?(kid)

    # validate payload
    sub = payload["sub"]
    raise "Invalid access token. 'Subject' (sub) must be a non-empty string." if sub.blank?

    # validate signature
    decoded_token, error = FirebaseIDTokenVerifier.decode_jwt_token(id_token, @firebase_project_id, public_key)
    raise error if decoded_token.nil?

    decoded_token
  end

  def self.decode_jwt_token(firebase_jwt_token, firebase_project_id, public_key)
    # Decode JWT token and validate
    #
    # Validation rules:
    # https://firebase.google.com/docs/auth/admin/verify-id-tokens#verify_id_tokens_using_a_third-party_jwt_library

    custom_options = { verify_iat: true,
                       verify_aud: true, aud: firebase_project_id,
                       verify_iss: true, iss: "https://securetoken.google.com/" + firebase_project_id }

    custom_options[:algorithm] = JWT_ALGORITHM unless public_key.nil?

    begin
      decoded_token = JWT.decode(firebase_jwt_token, public_key, !public_key.nil?, custom_options)
    rescue JWT::ExpiredSignature
      # Handle Expiration Time Claim: bad 'exp'
      return nil, "Invalid access token. 'Expiration time' (exp) must be in the future."
    rescue JWT::InvalidIatError
      # Handle Issued At Claim: bad 'iat'
      return nil, "Invalid access token. 'Issued-at time' (iat) must be in the past."
    rescue JWT::InvalidAudError
      # Handle Audience Claim: bad 'aud'
      return nil, "Invalid access token. 'Audience' (aud) must be your Firebase project ID, the unique identifier for your Firebase project."
    rescue JWT::InvalidIssuerError
      # Handle Issuer Claim: bad 'iss'
      return nil, "Invalid access token. 'Issuer' (iss) Must be 'https://securetoken.google.com/<projectId>', where <projectId> is your Firebase project ID."
    rescue JWT::VerificationError
      # Handle Signature verification fail
      return nil, "Invalid access token. Signature verification failed."
    end

    [decoded_token, nil]
  end

  def self.retrieve_and_cache_jwt_valid_public_keys
    # Get valid JWT public keys and save to cache
    #
    # Must correspond to one of the public keys listed at
    # https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com

    valid_public_keys = Rails.cache.read(VALID_JWT_PUBLIC_KEYS_RESPONSE_CACHE_KEY)
    if valid_public_keys.nil?
      uri = URI("https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com")
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      req = Net::HTTP::Get.new(uri.path)
      response = https.request(req)
      raise "Something went wrong: can't obtain valid JWT public keys from Google." if response.code != "200"

      valid_public_keys = JSON.parse(response.body)

      cc = response["cache-control"] # format example: Cache-Control: public, max-age=24442, must-revalidate, no-transform
      max_age = cc[/max-age=(\d+?),/m, 1] # get something between 'max-age=' and ','

      Rails.cache.write(VALID_JWT_PUBLIC_KEYS_RESPONSE_CACHE_KEY, valid_public_keys, expires_in: max_age.to_i)
    end

    valid_public_keys
  end
end
