class Shift < ActiveRecord::Base


	def self.fill_shift(shift)



			empty_shift = true;

			not_available = true;
			while not_available do 
				#pick random advisor
				rand_num = Advisor.count
				rand_advisor = Advisor.find(Random.rand(rand_num) + 4)
				puts "Found #{rand_advisor.name}"
				# is this advisor available?
				not_available = false if !Advisor.is_off?(shift, rand_advisor)
				puts "#{rand_advisor.name} can work this shift!" if !not_available
			end


	end



end
