module Queries
  module Flats
    class FindByAddressid < Service
      def call(scope: Flat, addressid:)
        scope.find_by_addressid(addressid)
      end
    end
  end
end
