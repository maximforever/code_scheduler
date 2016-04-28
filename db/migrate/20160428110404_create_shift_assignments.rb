class CreateShiftAssignments < ActiveRecord::Migration
  def change
    create_table :shift_assignments do |t|

      t.references :shift, index: true
      t.references :advisor, index: true
      t.datetime :start
      t.datetime :end	
      t.timestamps null: false
    end
  end
end
