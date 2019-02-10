module Fetchers
  module ActivityLogs
    class OnCreateError < Service
      def call(error:, activitable_type:, fetched_entity:)
        event_type = event_type(activitable_type)
        
        ActivityLog.create(
          event_type: event_type,
          event_log: error.message + "backtrace: #{error.backtrace}",
          event_name: event_name(event_type, fetched_entity, error)
        )
      end

      private

      def event_type(activitable_type)
        return :building_creation_error if activitable_type == :building
        return :flat_creation_error if activitable_type == :flat

        raise ArgumentError, "#{activitable_type.inspect} is not supported"
      end

      def event_name(event_type, fetched_entity, error)
        if event_type == :building_creation_error
          "New building nr #{fetched_entity.number} wasn't created due to #{error}"
        elsif event_type == :flat_creation_error
          "New flat nr #{fetched_entity.number} wasn't created due to #{error}" 
        else
          raise ArgumentError
        end
      end
    end
  end
end
