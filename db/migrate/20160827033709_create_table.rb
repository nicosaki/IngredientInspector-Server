class CreateTable < ActiveRecord::Migration
  def change
    create_table :contacteds do |t|
      t.string :upc
      t.string :uid
      t.boolean :contacted
      t.string :brand
      t.string :product
      t.timestamps null: false
    end
  end
end
