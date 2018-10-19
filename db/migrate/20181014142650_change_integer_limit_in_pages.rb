class ChangeIntegerLimitInPages < ActiveRecord::Migration[5.2]
  def change
     change_column :pages, :number, :integer, limit: 8
   end
end
