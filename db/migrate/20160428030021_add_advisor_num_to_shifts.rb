class AddAdvisorNumToShifts < ActiveRecord::Migration
  def change
  	add_column :shifts, :advisor_number, :integer, default: 0
  end
end
