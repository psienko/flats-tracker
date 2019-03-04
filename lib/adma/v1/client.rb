require 'open-uri'

module Adma
  module V1
    class Client
      BASE_URL = 'http://www.admadevelopment.pl/mieszkania/4?flat_finder_form_type%5BfloorNumberFrom%5D=0&flat_finder_form_type%5BfloorNumberTo%5D=8&flat_finder_form_type%5BroomNumberFrom%5D=1&flat_finder_form_type%5BroomNumberTo%5D=4&flat_finder_form_type%5BsurfaceFrom%5D=24&flat_finder_form_type%5BsurfaceTo%5D=77&flat_finder_form_type%5B_token%5D=yTfz982U5cRPtqGhgzoJ0jTLbgwFDoVJmrwAUPvseSk'

      def self.fetch
        new.fetch
      end

      def initialize(parser: ::Adma::V1::Parser)
        @parser = parser
      end

      
      def fetch
        doc = Nokogiri::HTML(open(BASE_URL))
        @parser.parse(doc)
      end
    end
  end
end
