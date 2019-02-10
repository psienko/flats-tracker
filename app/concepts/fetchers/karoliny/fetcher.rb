module Fetchers
  module Karoliny
    class Fetcher < Service
      def initialize(
        client:       ::Karoliny::V1::Client,
        synchronizer: ::Fetchers::Karoliny::Synchronizer
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
