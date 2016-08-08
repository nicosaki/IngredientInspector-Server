class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :eid
      t.string :name, null: false
      t.string :function
      t.string :warnings
      t.string :status
      t.string :foods
      t.string :details
      t.string :source
      t.string :other
      t.timestamps null: false
    end
  end
end
