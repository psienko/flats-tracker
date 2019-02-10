class CreateActivityLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_logs do |t|
      t.references :activitable, polymorphic: true
      t.string :event_type
      t.text :event_log
      t.string :event_name

      t.timestamps
    end
  end
end
