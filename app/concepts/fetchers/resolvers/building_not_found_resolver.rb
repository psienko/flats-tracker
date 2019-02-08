module Fetchers
  module Resolvers
    class BuildingNotFoundResolver
      def self.call(**args); new.call(**args); end

      def initialize(
        building_creator:      ::Fetchers::Creators::BuildingCreator,
        flat_creator:          ::Fetchers::Creators::FlatCreator,
        building_create_error: ::Fetchers::Creators::BuildingCreator::Error,
        flat_create_error:     ::Fetchers::Creators::FlatCreator::Error
      )
        @building_creator = building_creator
        @flat_creator = flat_creator
        @building_create_error = building_create_error
        @flat_create_error = flat_create_error
      end

      def call(building:, building_entity:, provider:)
        @building_creator.call(building: building)
        # TODO Log Activity
        create_flats(building, building_entity.flats, provider)
      rescue @building_create_error => e
        # TODO Log Activity
      end

      private

      def create_flats(building, flats_entity, provider)
        flats_entity.each do |flat|
          begin
            @flat_creator.call(building: building, flat_entity: flat, provider: provider)
            # TODO Log Activity
          rescue @flat_create_error => e
            # TODO Log Activity
          end
        end
      end
    end
  end
end
