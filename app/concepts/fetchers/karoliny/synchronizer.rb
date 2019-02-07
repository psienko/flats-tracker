module Fetchers
  module Karoliny
    class Synchronizer
      PROVIDER = 'osiedle karoliny'

      def self.call(args); new.call(args); end

      def call(building_entity)
        building = building(building_entity)
        synchronize_flats(building, building_entity.flats)
      end

      private

      def building(building_entity)
        Building.find_or_initialize_by(provider: PROVIDER, number: building_entity.number)
      end

      def synchronize_flats(building, flats)
        ActiveRecord::Base.transaction do
          if building.persisted?
            # TODO
          else
            building.flats = flats.map { |flat_entity| Flat.new(flat_entity.to_h) }
            building.save
          end 
        end
      end
    end
  end
end
