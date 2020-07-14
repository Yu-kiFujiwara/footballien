class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string, null: false, default: '', limit: 100
    add_column :users, :age, :integer
    add_column :users, :sex, :integer
    add_column :users, :job, :integer, null: false
    add_column :users, :location, :integer
    add_column :users, :introduction, :text
  end
end
