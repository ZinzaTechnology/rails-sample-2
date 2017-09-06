module CommonSpecHelper
  def sign_in(email:, password:)
    visit "/login"
    page.find_field("email").set(email)
    page.find_field("password").set(password)
    find(".btn-primary").click
  end

  def authenticated_header_for_user(user)
    verifier = FirebaseIDTokenVerifier.new(ENV["FIREBASE_PROJECT_ID"])
    rsa_private = OpenSSL::PKey::RSA.generate 2048
    encoded_token = verifier.encode(rsa_private, clinic[:uid], clinic[:email], clinic[:director])
    { 'Authorization': "Bearer #{encoded_token}" }
  end

  def authenticated_header_for_admin(admin)
    encoded_token = JsonWebToken.encode(admin_id: admin.id)
    { 'Authorization': encoded_token }
  end
end
