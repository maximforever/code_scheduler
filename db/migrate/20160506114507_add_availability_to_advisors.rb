class AddAvailabilityToAdvisors < ActiveRecord::Migration
  def change
  	add_column :advisors, :availability, :text
  end
end
