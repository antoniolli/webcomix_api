class CreateComics < ActiveRecord::Migration[5.2]
  def change
    create_table :comics do |t|
      t.string :name
      t.string :description
      t.boolean :is_public
      t.boolean :is_comments_active
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
