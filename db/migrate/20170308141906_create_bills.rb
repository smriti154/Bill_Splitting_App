class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :event
      t.date :bill_date
      t.string :location
      t.integer :total_amount

      t.timestamps null: false
    end
  end
end
