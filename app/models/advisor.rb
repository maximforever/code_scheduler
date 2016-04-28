class Advisor < ActiveRecord::Base
	belongs_to :shift

	def self.is_off?(shift, advisor)
		@vacations = Vacation.where(name: advisor.name)				#pull all the time off for this advisor
		puts "There are #{@vacations.length} vacations to test"
		start_valid = true;
		end_valid = true;

		@vacations.each do |v|										#for each time off

			puts "testing one!"

			start_valid = false if shift.start.between?(v.start, v.end)			#is the start of the shift during a time off?
			end_valid = false if shift.end.between?(v.start, v.end)				# is the end of the shift during a time off?
		end

		if !start_valid
			puts "start overlaps"
			return true
		elsif !end_valid
			puts "end overlaps"
			return true
		else
			puts "This advisor can work!"
			return false
		end	
	end

	def self.hours_today(date)
		
	end


end
