class Advisor < ActiveRecord::Base
	has_many :shift_assignments
	has_many :shifts, :through => :shift_assignments

	def available?(shift)
		@vacations = Vacation.where(name: self.name)				#pull all the time off for this advisor
		puts "#{self.name}: There are #{@vacations.length} vacation records to test"
		start_valid = true;
		end_valid = true;

		@vacations.each do |v|										#for each time off
			start_valid = false if shift.start.between?(v.start, v.end)			#is the start of the shift during a time off?
			end_valid = false if shift.end.between?(v.start, v.end)				# is the end of the shift during a time off?
		end

		if !start_valid
			puts "Can't work - start time overlaps"
			return false
		elsif !end_valid
			puts "Can't work - end time overlaps"
			return false
		else
			puts "#{self.name} can work"
			return true
		end	
	end

	def hours_today(date)

		advisor = Advisor.find(self.id)
		
	end

	def totalHours

		advisor = Advisor.find(self.id)

		total_hrs = 0

		advisor.shifts.each {|s| total_hrs += s.getLength}
		puts "#{advisor.name} is working a total of #{total_hrs}/#{advisor.max_hours} hours this week"
		return total_hrs

	end

	def notOnShift?(shift)	

		on_this_shift = false
		on_today = false

		if shift.advisors.include?(self)					#is the advisor already on this shift?
			puts "#{self.name} is already on this shift."
			on_this_shift = true
			return false 
		end
							
		self.shifts.each do |s|			#go through all the shifts and check that none of them are today
			puts "testing shift on #{s.start}"

			puts s.start.day
			puts shift.start.day
			puts s.start.month
			puts shift.start.month

			if (s.start.day.to_i == shift.start.day.to_i && s.start.month.to_i == shift.start.month.to_i)
				"#{self.name} is already working that day, on #{shift.start.month}/#{shift.start.day}"
				on_today = true
				return false
			end		
		end

		if (!(on_today) || !(on_this_shift))		# the ugliest line of code I've ever written
			puts "The advisor is good to work this shift"
			return true 
		end
	end
=begin

	def onShiftThisWeek?(shift)
			self.shifts.each do |s|
				puts "testing shift"
				if (s.start.day == shift.start.day && s.start.month == shift.start.month)
					"#{self.name} is already working that day, on #{shift.start.month}/#{shift.start.day}"
					return false
				end		
			return true
		end
	end
=end





	def ring
		return true
	end


end
