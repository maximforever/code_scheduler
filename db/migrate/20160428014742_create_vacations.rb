class CreateVacations < ActiveRecord::Migration
  def change
    create_table :vacations do |t|

      t.datetime :start
      t.datetime :end 	
      
      t.references :advisor
      t.timestamps null: false
    end
  end
end
