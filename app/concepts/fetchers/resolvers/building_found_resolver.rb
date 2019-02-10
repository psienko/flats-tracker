module Fetchers
  module Resolvers
    class BuildingFoundResolver < Service
      def initialize(
        flat_updater:                   ::Fetchers::Updaters::FlatUpdater,
        flat_update_error:              ::Fetchers::Updaters::FlatUpdater::UpdateError,
        flat_create_error:              ::Fetchers::Updaters::FlatUpdater::CreateError,
        activity_logger:                ::Fetchers::ActivityLogs::OnFlatUpdate,
        activity_creation_error_logger: ::Fetchers::ActivityLogs::OnCreateError,
        activity_update_error_logger:   ::Fetchers::ActivityLogs::OnFlatUpdateError
      )
        @flat_updater = flat_updater
        @flat_update_error = flat_update_error
        @flat_create_error = flat_create_error
        @activity_logger = activity_logger
        @activity_creation_error_logger = activity_creation_error_logger
        @activity_update_error_logger = activity_update_error_logger
      end

      def call(building:, building_entity:, provider:)
        building_entity.flats.each do |flat_entity|
          update_flat(building, flat_entity, provider)
        end
      end

      private

      # TODO Implement Event Sourcing
      # Event should be published from creators/updaters and Activity logging
      # should be doing in separate class
      def update_flat(building, flat_entity, provider)
        flat = @flat_updater.call(
          building: building,
          flat_entity: flat_entity,
          provider: provider
        )
        @activity_logger.call(flat: flat, fetched_entity: flat_entity)
      rescue @flat_update_error => e
        @activity_update_error_logger.call(
          error: e,
          building: building,
          fetched_entity: flat_entity
        )
      rescue @flat_create_error => e
        @activity_creation_error_logger.call(
          error: e,
          activitable_type: :flat,
          fetched_entity: flat_entity
        )
      end
    end
  end
end
