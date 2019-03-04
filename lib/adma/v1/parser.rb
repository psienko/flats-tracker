module Adma
  module V1
    class Parser
      NOT_AVAILABLE_BUILDINGS = %w(2 3 5 6)

      def self.parse(doc)
        new.parse(doc)
      end

      def initialize(
        headers_mapper:  Adma::V1::Mappers::Header,
        building_entity: Adma::V1::Entities::Building,
        flat_entity:     Adma::V1::Entities::Flat
      )
        @headers_mapper = headers_mapper
        @building_entity = building_entity
        @flat_entity = flat_entity
      end

      def parse(doc)
        table = doc.css('table')
        headers = parse_headers(table)
        flats_hash = parse_flats(table, headers)
        buildings_with_flats = flats_hash.group_by { |flat_hash| flat_hash[:building_number] }
        filter_available_buildings(buildings_with_flats)
      end

      private

      def parse_headers(table)
        headers = table.at_css('thead').css('th').map{|th| th.text.strip}
        @headers_mapper.call(headers)
      end

      def parse_flats(table, headers)
        rows = table.at_css(:tbody).css('tr')

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

          result
        end
      end

      def parse_field(col, header)
        if header == :concept_url && file = col&.css('a')&.attribute('href')&.value
          return URI.join('http://www.admadevelopment.pl', URI.escape(file))
        end

        value = col.text.strip
        return Monetize.parse(value) if header == :price

        value
      end

      def parsed_headers(headers_row)
        headers = headers_row.css('td').map(&:text)
        @headers_mapper.call(headers)
      end

       def filter_available_buildings(buildings_with_flats)
        buildings_with_flats.map do |building, flats|
          building_no = building.match(/\d+/).to_s

          next if NOT_AVAILABLE_BUILDINGS.include?(building_no)
          flats = flats.map { |flat| @flat_entity.new(flat) }
          @building_entity.new(number: building_no, flats: flats)
        end.compact
      end
    end
  end
end
