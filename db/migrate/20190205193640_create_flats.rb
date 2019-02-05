class CreateFlats < ActiveRecord::Migration[6.0]
  def change
    create_table :flats do |t|
      t.string :addressid
      t.string :number
      t.float :area
      t.string :area_unit, default: 'm2'
      t.integer :floor_number
      t.integer :room_count
      t.monetize :price
      t.string :concept_url
      t.references :building

      t.timestamps
    end
  end
end
