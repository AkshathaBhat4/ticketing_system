class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.integer :customer_id, index: true
      t.integer :agent_id, index: true
      t.references :state, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
