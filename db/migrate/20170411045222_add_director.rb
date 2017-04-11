class AddDirector < ActiveRecord::Migration
  def change
    add_column :products, :director, :string
    add_column :products, :detail, :text
  end
end
