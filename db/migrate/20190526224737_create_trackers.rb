class CreateTrackers < ActiveRecord::Migration[5.2]
  def change
    create_table :trackers do |t|
      t.string :asset_1
      t.string :asset_2
      t.date :start_date

      t.timestamps
    end
  end
end
