module Adma
  module V1
    module Entities
      class Building < Dry::Struct
        attribute :number, ::Types::Coercible::Integer
        attribute :flats, ::Types::Coercible::Array.of(Flat)
      end
    end
  end
end
