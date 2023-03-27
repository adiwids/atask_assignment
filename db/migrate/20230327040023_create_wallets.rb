class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.bigint :owner_id
      t.string :owner_type
      t.monetize :balance

      t.timestamps
    end

    add_index :wallets, %i[owner_id owner_type], name: 'wallets_owner_idx'
  end
end
