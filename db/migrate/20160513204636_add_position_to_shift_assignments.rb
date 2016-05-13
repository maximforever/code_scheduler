class AddPositionToShiftAssignments < ActiveRecord::Migration
  def change
  	add_column :shift_assignments, :position, :string
  	remove_column :advisors, :position, :string
  end
end
