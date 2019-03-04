module Adma
  module V1
    module Entities
      class Flat < Dry::Struct
        attribute :number,       ::Types::Coercible::String
        attribute :area,         ::Types::Coercible::Float
        attribute :area_unit,    ::Types::Coercible::String
        attribute :floor_number, ::Types::Coercible::String
        attribute :room_count,   ::Types::Coercible::Integer
        attribute :status,       ::Types::Coercible::String
        attribute :price,        ::Types.Constructor(Money)
        attribute :concept_url,  ::Types::Coercible::String
      end
    end
  end
end
