module Fetchers
  module ActivityLogs
    class OnCreate < Service
      def call(activitable:, fetched_entity: nil)
        event_type = event_type(activitable)
        
        ActivityLog.create(
          activitable: activitable,
          event_type: event_type,
          event_log: "Fetched #{fetched_entity.inspect} and created #{activitable.inspect}",
          event_name: event_name(activitable, event_type)
        )
      end

      private

      def event_type(activitable)
        return :new_building_created if activitable.is_a?(Building)
        return :new_flat_created if activitable.is_a?(Flat)

        raise ArgumentError, "#{activitable.inspect} is not supported"
      end

      def event_name(activitable, event_type)
        if event_type == :new_building_created
          "New building nr #{activitable.number} was created"
        elsif event_type == :new_flat_created
          "New flat nr #{activitable.number} was created for building #{activitable.building_number}" 
        else
          raise ArgumentError
        end
      end
    end
  end
end
