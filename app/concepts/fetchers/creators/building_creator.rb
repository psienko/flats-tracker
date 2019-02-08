module Fetchers
  module Creators
    class BuildingCreator < Service
      Error = Class.new(BaseError)

      # TODO Implement Event Sourcing
      def call(building:)
        building.save!
      rescue StandardError => e
        raise Error.new(e, building: building)
      end
    end
  end
end
