class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.string :address
      t.string :address_two
      t.integer :list_price
      t.integer :sold_price
      t.integer :original_price
      t.integer :taxes
      t.integer :days_on_market
      t.string :spis
      t.date :list_date
      t.date :sold_date
      t.timestamps
    end
  end
end
