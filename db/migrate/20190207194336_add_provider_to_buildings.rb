class AddProviderToBuildings < ActiveRecord::Migration[6.0]
  def change
    add_column :buildings, :provider, :string
  end
end
