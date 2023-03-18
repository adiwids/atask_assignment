class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.bigint :team_id
      t.bigint :member_id
      t.integer :status, limit: 1, default: 0

      t.timestamps
    end

    add_foreign_key :memberships, :teams
    add_foreign_key :memberships, :users, column: 'member_id'
    add_index :memberships, [:team_id, :member_id], name: 'memberships_idx'
  end
end
