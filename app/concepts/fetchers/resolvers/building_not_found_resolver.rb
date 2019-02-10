module Fetchers
  module Resolvers
    class BuildingNotFoundResolver < Service
      def initialize(
        building_creator:      ::Fetchers::Creators::BuildingCreator,
        flat_creator:          ::Fetchers::Creators::FlatCreator,
        building_create_error: ::Fetchers::Creators::BuildingCreator::Error,
        flat_create_error:     ::Fetchers::Creators::FlatCreator::Error,
        activity_logger:       ::Fetchers::ActivityLogs::OnCreate,
        activity_error_logger: ::Fetchers::ActivityLogs::OnCreateError
      )
        @building_creator = building_creator
        @flat_creator = flat_creator
        @building_create_error = building_create_error
        @flat_create_error = flat_create_error
        @activity_logger = activity_logger
        @activity_error_logger = activity_error_logger
      end

      def call(building:, building_entity:, provider:)
        @building_creator.call(building: building)
        log_success(building, building_entity)
        create_flats(building, building_entity.flats, provider)
      rescue @building_create_error => e
        log_error(building_entity, e, :building)
      end

      private

      def create_flats(building, flats_entity, provider)
        flats_entity.each do |flat_entity|
          begin
            flat = @flat_creator.call(building: building, flat_entity: flat_entity, provider: provider)
            log_success(flat, flat_entity)
          rescue @flat_create_error => e
            log_error(flat_entity, e, :flat)
          end
        end
      end

      def log_success(activitable, entity)
        @activity_logger.call(activitable: activitable, fetched_entity: entity)
      end

      def log_error(entity, error, type)
        @activity_error_logger.call(error: error, activitable_type: type, fetched_entity: entity)
      end
    end
  end
end
