class RetypePositionToAdvisor < ActiveRecord::Migration

  def up
  	change_column :advisors, :position, :string
  end
  
  def down
  	change_column :advisors, :position, :boolean
  end

end
