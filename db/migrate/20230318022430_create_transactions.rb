class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_type, index: true, null: false # STI column
      t.datetime :date_time, index: true, default: Time.zone.now
      t.bigint :owner_id
      t.string :owner_type, index: true, null: false
      t.string :owner_name, index: true
      t.monetize :amount

      t.timestamps
    end

    add_index :transactions, [:owner_id, :owner_type], name: 'transactions_owner_idx'
  end
end
