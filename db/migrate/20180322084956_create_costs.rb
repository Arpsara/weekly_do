class CreateCosts < ActiveRecord::Migration[5.1]
  def change
    create_table :costs do |t|
      t.decimal :price
      t.references :user
      t.references :project

      t.timestamps
    end
  end
end
