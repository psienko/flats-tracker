module Fetchers
  module ActivityLogs
    class OnFlatUpdateError < Service
      def call(error:, building:, fetched_entity:)
        ActivityLog.create(
          event_type: :flat_update_error,
          event_log: error.message,
          event_name: "Flat #{building.number}/#{fetched_entity.number} wasn't updated due to #{error}"
        )
      end
    end
  end
end
