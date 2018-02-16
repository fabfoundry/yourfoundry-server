require 'jwt'

class Auth

  ALGORITHM = "HS256"

  def self.issue(payload)
    JWT.encode(
      payload,
      auth_secret,
      ALGORITHM)
  end

  def self.decode(token)
      JWT.decode(token,
        auth_secret,
        true,
        { algorithm: ALGORITHM }).first
  end

  def self.auth_secret
    if Rails.env.development?
     Rails.application.secrets.AUTH_SECRET
    elsif Rails.env.test?
      ENV["AUTH_SECRET"]
    end
  end

end
