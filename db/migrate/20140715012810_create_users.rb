class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :locations_of_interest, array: true, default: '{}'

      t.timestamps
    end
  end
end
