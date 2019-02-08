module Fetchers
  module Karoliny
    class Synchronizer
      PROVIDER = 'osiedle_karoliny'

      def self.call(args); new.call(args); end

      def initialize(
        building_not_found_resolver: ::Fetchers::Resolvers::BuildingNotFoundResolver
      )
        @building_not_found_resolver = building_not_found_resolver
      end

      def call(building_entity)
        building = building(building_entity)
        synchronize_flats(building, building_entity)
      end

      private

      def building(building_entity)
        Building.find_or_initialize_by(provider: PROVIDER, number: building_entity.number)
      end

      def synchronize_flats(building, building_entity)
          if building.persisted?
            # TODO
          else
            resolve_not_found_building(building, building_entity)
          end 
      end

      def resolve_not_found_building(building, building_entity)
        @building_not_found_resolver.call(
          building:building,
          building_entity: building_entity,
          provider: PROVIDER
        )
      end
    end
  end
end
