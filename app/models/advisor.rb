class Advisor < ActiveRecord::Base
	has_many :shift_assignments
	has_many :shifts, :through => :shift_assignments
	has_many :vacations
	serialize :availability, Array

	def available?(shift)
#		vacations = Vacation.where(name: self.name)				#pull all the time off for this advisor
		vacations = self.vacations 		#this should be slightly faster
		puts "#{self.name}: There are #{vacations.length} vacation records to test"
		start_valid = true;
		end_valid = true;

		vacations.each do |v|										#for each time off
			start_valid = false if shift.start.between?(v.start, v.end)			#is the start of the shift during a time off?
			end_valid = false if shift.end.between?(v.start, v.end)				# is the end of the shift during a time off?
		end

		if !start_valid
			puts "XX Can't work - start time overlaps"
			return false
		elsif !end_valid
			puts "XX Can't work - end time overlaps"
			return false
		else
			puts "#{self.name} can work"
			return true
		end	
	end

	def notOnShift?(shift)	

		on_this_shift = false
		on_today = false

		# this block of code checks if the advisor is on today AND on this shift - do we only need to check if on today?

		if shift.advisors.include?(self)					#is the advisor already on this shift?
			puts "#{self.name} is already on this shift."
			on_this_shift = true
			return false 
		end

		self.shifts.each do |s|			#go through all the shifts and check that none of them are today
			puts "testing shift on #{shift.start.month}/#{shift.start.day}"

			if (s.start.day.to_i == shift.start.day.to_i && s.start.month.to_i == shift.start.month.to_i)
				"#{self.name} is already working that day, on #{shift.start.month}/#{shift.start.day}"
				on_today = true
				return false
			end		
		end

		if (!(on_today) && !(on_this_shift))		# the ugliest line of code I've ever written  
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

	def self.setAvailability
		advisors = Advisor.all
		shifts = Shift.all


		advisors.each do |a|				# cycle through each advisor
			shifts.each do |s|
				if a.available?(s)
					a.availability.push(1)
				else
					a.availability.push(0)
				end
			end
			a.save
		end
	end

	def maxHours
		max_hours_available = 0

		(0..6).each do |i|
			max_hours_available += self.availability[i]*2
		end

		(7..27).each do |i|
			max_hours_available += self.availability[i]*4
		end

		(28..34).each do |i|
			max_hours_available += self.availability[i]*2
		end

		max_hours_available = 40 if max_hours_available > 40

		puts "#{self.name} can work #{max_hours_available} hours this week"
		return max_hours_available
	end

	def utilized
		util = 0
		if self.maxHours == 0
			puts "This advisor is unavailable"
			util = 9.99
		else
			puts "This advisor is available"
			util = self.totalHours.to_f/self.maxHours.to_f
		end

		return util
	end





	def ring
		return true
	end


end
