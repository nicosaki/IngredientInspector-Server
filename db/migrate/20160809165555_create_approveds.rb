class CreateApproveds < ActiveRecord::Migration
  def change
    create_table :approveds do |t|
      t.string :uid
      t.string :upc
      t.string :product_name
      t.string :brand
      t.timestamps null: false
    end
  end
end
