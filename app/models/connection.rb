class Connection
  class << self
    def site
      APP_CONFIG[:site][Rails.env]
    end

    def get(uri)
      RestClient.get("#{site}#{uri}")
    end

    def post(uri, attributes)
      RestClient.post("#{site}#{uri}", attributes)
    end

    def put(uri, attributes)
      RestClient.put("#{site}#{uri}", attributes)
    end

    def delete(uri)
      RestClient.delete("#{site}#{uri}")
    end
  end
end
