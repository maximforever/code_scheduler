class Vacation < ActiveRecord::Base
	belongs_to :advisor




  def self.fillid

    Vacation.all.each do |v|

      adv = Advisor.find_by_name(v.name)

      unless adv.nil?
        v.advisor_id = adv.id 
        v.save
      end

    end
  end


end
