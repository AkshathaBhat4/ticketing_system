class AddColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :user_type, foreign_key: true
    add_column :users, :name, :string
  end
end
