require 'open-uri'

module Karoliny
  module V1
    class Client
      BASE_URL = 'http://karoliny.pl/index.php/oferta_nr37/'

      def self.fetch
        new.fetch
      end

      def initialize(parser: ::Karoliny::V1::Parser)
        @parser = parser
      end

      
      def fetch
        doc = Nokogiri::HTML(open(BASE_URL))
        @parser.parse(doc)
      end
    end
  end
end
