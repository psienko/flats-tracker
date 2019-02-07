module Karoliny
  module V1
    class Parser
      def self.parse(doc)
        new.parse(doc)
      end

      def initialize(
        headers_mapper:  Karoliny::V1::Mappers::Header,
        building_entity: Karoliny::V1::Entities::Building,
        flat_entity:     Karoliny::V1::Entities::Flat
      )
        @headers_mapper = headers_mapper
        @building_entity = building_entity
        @flat_entity = flat_entity
      end

      def parse(doc)
        buildings_divs = doc.css("div.ui-tabs-panel")
        result = {}

        buildings_divs.map do |div|
          building_number = div.attributes["id"].text&.scan(/[\d]+/).first
          @building_entity.new(number: building_number, flats: parsed_rows(div))
        end
      end

      private

      def parsed_rows(building_div)
        table = building_div.at_css('table')
        headers, *rows = table.css('tr')
        headers = parsed_headers(headers)

        rows.map do |row|
          fields = row.css('td')
          result = {}

          fields.each_with_index do |field, idx|
            header = headers[idx]
            if header == :area
              value = parse_field(field, header)
              area = value.scan(/[\d+\.|,]+/).first
              result[:area] = area.gsub(',', '.')
              result[:area_unit] = value.gsub(area, '').strip
            else
              result[header] = parse_field(field, header)
            end
          end

          @flat_entity.new(result)
        end
      end

      def parse_field(col, header)
        return col.text unless header == :concept_url


        col.css('a').attribute('href').value
      end

      def parsed_headers(headers_row)
        headers = headers_row.css('td').map(&:text)
        @headers_mapper.call(headers)
      end
    end
  end
end
