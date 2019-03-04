module Adma
  module V1
    module Mappers
      class Header
        def self.call(headers)
          new.call(headers)
        end

        def call(headers)
          headers.map { |header| mapping_rule[header] }
        end

        private

        def mapping_rule
          {
            'Mieszkanie' => :number,
            'Budynek' => :building_number,
            'Etap' => :stage,
            'Piętro' => :floor_number,
            'Pokoje' => :room_count,
            'Metraż' => :area,           
            'Cena' => :price,
            'Status' => :status,
            'Zobacz' => :concept_url
          }
        end
      end
    end
  end
end
