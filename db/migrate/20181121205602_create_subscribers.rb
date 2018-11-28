class CreateSubscribers < ActiveRecord::Migration[5.2]
  def change
    create_table :subscribers do |t|
      t.boolean :is_blocked
      t.references :comic, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
