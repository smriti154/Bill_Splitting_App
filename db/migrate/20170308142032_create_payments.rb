class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :bill_id
      t.integer :paid_amount

      t.timestamps null: false
    end
  end
end
