class AddressidGenerator < Service
  def call(provider:, building:, flat:)
    "#{provider}-#{building.number}-#{flat.number}"
  end
end
