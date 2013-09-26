module SocialRebate

  class Config

    @@api_key = @@api_secret = @@store_key = nil
    @@enabled     = true
    @@api_version = 'v2'

    class << self
      def api_key=(key)
        @@api_key = key
      end

      def api_secret=(secret)
        @@api_secret = secret
      end

      def store_key=(store_key)
        @@store_key = store_key
      end

      def api_version=(api_version)
        @@api_version = api_version || 'v2'
      end

      def enabled=(enabled=true)
        @@enabled = enabled
      end

      def api_key
        @@api_key || ENV['SR_API_KEY']
      end

      def api_secret
        @@api_secret || ENV['SR_API_SECRET']
      end

      def store_key
        @@store_key || ENV['SR_STORE_KEY']
      end

      def api_version
        @@api_version
      end

      def enabled?
        @@enabled
      end

      def api_version
        @@api_version
      end
    end

  end

end
