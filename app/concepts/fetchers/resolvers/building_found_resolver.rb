module Fetchers
  module Resolvers
    class BuildingFoundResolver < Service
      def initialize(
        flat_updater:      ::Fetchers::Updaters::FlatUpdater,
        flat_update_error: ::Fetchers::Updaters::FlatUpdater::CreateError,
        flat_create_error: ::Fetchers::Updaters::FlatUpdater::UpdateError
      )
        @flat_updater = flat_updater
        @flat_update_error = flat_update_error
        @flat_create_error = flat_create_error
      end

      def call(building:, building_entity:, provider:)
        building_entity.flats.each do |flat_entity|
          update_flat(building, flat_entity, provider)
        end
      end

      private

      # TODO Implement Event Sourcing
      # Event shoud be published from creators/updaters and Activity logging
      # should be doing in separate class
      def update_flat(building, flat_entity, provider)
        flat = @flat_updater.call(
          building: building,
          flat_entity: flat_entity,
          provider: provider
        )
        # TODO Log Activity
        # if id_previously_changed? then flat was created
        # if !id_previously_changed? && flat.previous_changes.except(:created_at, :updated_at).blank? NO CHANGES
        # if !id_previously_changed? && flat.previous_changes.except(:created_at, :updated_at).present? MODIFIED
        
        flat
      rescue @flat_update_error => e
        # TODO Log Activity
      rescue @flat_create_error => e
        # TODO Log Activity
      end
    end
  end
end
