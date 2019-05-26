class CreateTrackers < ActiveRecord::Migration[5.2]
  def change
    create_table :trackers do |t|
      t.string :name
      t.string :asset_one
      t.string :asset_two
      t.date :start_date
      t.integer :user_id

      t.timestamps
    end
  end
end
