module Fetchers
  module Adma
    class Fetcher < Service
      def initialize(
        client:       ::Adma::V1::Client,
        synchronizer: ::Fetchers::Adma::Synchronizer
      )
        @client = client
        @synchronizer = synchronizer
      end

      def call
        result = @client.fetch
        result.map do |building_entity|
          @synchronizer.call(building_entity)
        end
      end
    end
  end
end
