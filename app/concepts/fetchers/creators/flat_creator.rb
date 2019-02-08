module Fetchers
  module Creators
    class FlatCreator < Service
      Error = Class.new(BaseError)

      def initialize(addressid_generator: ::AddressidGenerator)
        @addressid_generator = addressid_generator
      end

      # TODO Implement Event Sourcing
      def call(building:, flat_entity:, provider:)
        flat_args = flat_args(building, flat_entity, provider)
        Flat.create!(flat_args)
      rescue StandardError => e
        raise Error.new(e, building: building, flat_entity: flat_entity, provider: provider)
      end

      private

      def flat_args(building, flat_entity, provider)
        args = flat_entity.to_h
        args[:addressid] = @addressid_generator.call(
          building: building, flat: flat_entity, provider: provider
        )
        args[:building] = building

        args
      end
    end
  end
end
