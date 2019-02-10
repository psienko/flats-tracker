module Fetchers
  module ActivityLogs
    class OnFlatUpdate < Service
      def initialize(
        create_logger: ::Fetchers::ActivityLogs::OnCreate,
        policy:        ::Flats::ResolvePolicy
      )
        @create_logger = create_logger
        @policy = policy
      end

      def call(flat:, fetched_entity: nil)
        policy_object = @policy.new(flat)
        if policy_object.created?
          @create_logger.call(activitable: flat, fetched_entity: fetched_entity)
        elsif policy_object.status_changed?
          log_status_change(flat, fetched_entity)
        elsif policy_object.changed?
          log_change(flat, fetched_entity)
        else
          # NO CHANGES 
        end
      end

      private

      def log_status_change(flat, flat_entity)
        event_type = :flat_status_changed
        event_log = "Fetched #{flat_entity.inspect} and updated #{flat.inspect} with changes #{flat.previous_changes.inspect}"
        event_name = "Flat #{flat.building_number}/#{flat.number} was changed status "\
                      "from #{flat.previous_changes[:status][0]} to #{flat.previous_changes[:status][1]}"

        log(flat: flat, event_type: event_type, event_log: event_log, event_name: event_name)
      end

      def log_change(flat, flat_entity)
        event_type = :flat_updated
        event_log = "Fetched #{flat_entity.inspect} and updated #{flat.inspect} with changes #{flat.previous_changes.inspect}"
        changes = flat.previous_changes.map do |field, changes|
         "#{field} changed from #{changes[0]} to #{changes[1]} \n" 
        end.join
        event_name = "Flat #{flat.building_number}/#{flat.number} was updated with "\
                     "following changes: \n#{changes}"
        log(flat: flat, event_type: event_type, event_log: event_log, event_name: event_name)
      end

      def log(flat:, event_type:, event_log:, event_name:)
        ActivityLog.create(
          activitable: flat,
          event_type: event_type,
          event_log: event_log,
          event_name: event_name
        )
      end
    end
  end
end
