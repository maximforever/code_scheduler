class RemoveColumnFromAdvisors < ActiveRecord::Migration
  def change
  	remove_column :advisors, :shift_id, :integer
  end
end
