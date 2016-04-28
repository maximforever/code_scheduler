class AddNameToVacation < ActiveRecord::Migration
  def change
  	add_column :vacations, :name, :string
  end
end
