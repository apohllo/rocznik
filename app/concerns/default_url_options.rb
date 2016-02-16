module DefaultUrlOptions

  # Including this file sets the default url options. This is useful for mailers or background jobs

  def default_url_options
    {
    host: host,
    port: port
    }
  end

  private

  def host
    if Rails.env.staging?
      "localhost:3000"
    else
      "rocznik.kognitywistyka.eu"
    end
  end

  def port
    80
  end

end
