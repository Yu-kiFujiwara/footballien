class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.bigint :owner_id, foreign_key: true
      t.bigint :player_id, foreign_key: true

      t.timestamps
    end
  end
end
