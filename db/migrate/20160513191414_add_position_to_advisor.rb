class AddPositionToAdvisor < ActiveRecord::Migration
    def change
	  	add_column :advisors, :position, :boolean
	  end
end
