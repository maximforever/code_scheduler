class Advisor < ActiveRecord::Base
	belongs_to :shift

	def self.is_off?(shift, advisor)
		@vacations = Vacation.where(name: advisor.name)				#pull all the time off for this advisor

		start_valid = true;
		end_valid = true;

		@vacations.each do |v|										#for each time off

			puts "testing one!"

			start_valid = false if shift.start.between?(v.start, v.end)			#is the start of the shift during a time off?
			end_valid = false if shift.end.between?(v.start, v.end)				# is the end of the shift during a time off?
		end

		if !start_valid || !end_valid
			puts "start overlaps"
			return true
		else
			puts "end overlaps"
			return false
		end	
	end


end
