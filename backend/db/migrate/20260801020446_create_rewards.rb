class CreateRewards < ActiveRecord::Migration[7.1]
  def change
    create_table :rewards do |t|
      t.string :name, null: false
      t.text :description
      t.integer :points_cost, null: false

      t.timestamps
    end
  end
end
