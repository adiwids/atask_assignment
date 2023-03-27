class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :name, index: true, unique: true
      t.bigint :owner_id, index: true, null: true
      t.integer :members_count, default: 0

      t.timestamps
    end
  end
end
