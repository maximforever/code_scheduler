class Shift < ActiveRecord::Base


	def self.fill_shift(shift)

			
			#pick random advisor
			rand_num = Advisor.count
			rand_advisor = Advisor.find(Random.rand(rand_num) + 4)
			puts "Found #{rand_advisor.name}"
			# is this advisor available?
			Advisor.is_off?(shift, rand_advisor)



	end



end
