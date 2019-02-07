module Karoliny
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
            'Powierzchnia' => :area,
            'Piętro' => :floor_number,
            'Liczba pokoi' => :room_count,
            'Cena' => :price,
            'Status' => :status,
            'Koncepcja mieszkania' => :concept_url
          }
        end
      end
    end
  end
end
