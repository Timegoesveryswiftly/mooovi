class AddOpenDate < ActiveRecord::Migration
  def change
    add_column :products, :open_date, :string
  end
end
