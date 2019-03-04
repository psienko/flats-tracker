module Fetchers
  module Updaters
    class FlatUpdater < Service
      Error = Class.new(BaseError)
      CreateError = Class.new(Error)
      UpdateError = Class.new(Error)

      def initialize(
        addressid_generator: ::AddressidGenerator,
        flat_finder:         ::Queries::Flats::FindByAddressid,
        flat_creator:        ::Fetchers::Creators::FlatCreator,
        flat_create_error:   ::Fetchers::Creators::FlatCreator::Error
      )
        @addressid_generator = addressid_generator
        @flat_finder = flat_finder
        @flat_creator = flat_creator
        @flat_create_error = flat_create_error
      end

      # TODO Implement Event Sourcing
      def call(building:, flat_entity:, provider:)
        addressid = @addressid_generator.call(building: building, flat: flat_entity, provider: provider)
        flat = @flat_finder.call(scope: building.flats, addressid: addressid)
        if flat
          update(flat, flat_entity)
        else
          create(building, flat_entity)
        end
      end

      private

      def create(building, flat_entity)
        @flat_creator.call(
          building: building,
          flat_entity: flat_entity,
          provider: building.provider
        )
      rescue @flat_create_error => e
        raise CreateError, e.message
      end

      def update(flat, flat_entity)
        attrs = flat_entity.to_h
        # We don't want to remove previously saved url
        attrs.delete :concept_url if attrs[:concept_url].blank? 
        flat.assign_attributes(attrs)
        return flat unless flat.changed?

        flat.save!
        flat
      rescue StandardError => e
        raise UpdateError.new(e.message, flat: flat, attrs: attrs)
      end
    end
  end
end
