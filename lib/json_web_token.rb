class JsonWebToken
  def self.encode(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base.to_s, "HS256")
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base.to_s, true, algorithm: "HS256")[0]
  rescue StandardError
    nil
  end
end
