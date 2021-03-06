class CiberSquash < Sinatra::Base
  register(Sinatra::Namespace)
  enable(:sessions)
  set(:sessions, expire_after: 2592000)
  set(:session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) })


  use OmniAuth::Builder do
    provider(:google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {})
    provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_SECRET'], :scope => 'email,read_stream'
  end

  configure :production do
    set(:clean_trace, true)
    set(:logging, Logger::INFO)
  end

  configure :development do
    set(:logging, Logger::DEBUG)
  end

  def admin?
    logged_in?
  end

  def logged_in?
    session[:uid]
  end

  get '/' do
    haml(:index)
  end

  # Errors
  not_found do
    haml(:'404')
  end

  error do
    haml(:errors)
  end
end
