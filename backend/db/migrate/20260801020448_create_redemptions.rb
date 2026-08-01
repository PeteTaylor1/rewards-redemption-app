class CreateRedemptions < ActiveRecord::Migration[7.1]
  def change
    create_table :redemptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reward, null: false, foreign_key: true
      t.integer :points_spent, null: false

      t.timestamps
    end

    add_index :redemptions, [:user_id, :created_at]
  end
end
