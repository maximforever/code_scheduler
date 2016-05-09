class Shift < ActiveRecord::Base
	has_many :shift_assignments
	has_many :advisors, :through => :shift_assignments



	def self.fillAllShifts						# the nuclear option
		all_shifts = Shift.all

		all_shifts.each do |shift|			
			shift.fillShift
		end
	end

	def self.fillVacations
		Vacation.all.each do |v|
			a = Advisor.find_by_name(v.name)
			v.advisor_id = a.id unless a.nil?
			v.save
		end
	end


	def fillShift

		puts "STARTING ==================================="
		puts "There are currently advisors #{self.advisors.count}/#{self.advisor_number} on shift"

		proficiency_bar = 3				# this is pretty important - how much proficiency (max 5 per advisor) do we want for each course per shift?
		min_skill = 2							# how well should an advisor know a course to get on shif?

		rails_try = 0							# we reset how many times we're going to try to fill each of these courses
		angular_try = 0
		python_try = 0
		php_try = 0
		simple_try = 0

		shiftNotFilled = true


		while(shiftNotFilled)		#while the shift hasn't been manually filled [cause we're out of adviors] OR we've filled it completely [with good advisors]
			if (self.advisors.count < self.advisor_number)
				puts "Looking for our next advisor!"
				puts "There are currently advisors #{self.advisors.count}/#{self.advisor_number} on shift"
				rand_advisor = Advisor.order("Random()").first			# pick random advisor
				puts "==>Random advisor pulled: #{rand_advisor.name}"

				if rand_advisor.available?(self)					# check that advisor is available
					if rand_advisor.notOnShift?(self)				# check that advisor isn't already on shift

						puts "#{rand_advisor.name} is available; testing"
						puts "Proficiency tries: Rails: #{rails_try}, Angular: #{angular_try}, Python: #{python_try}, PHP: #{php_try}, other: #{simple_try}"

						if self.rails < proficiency_bar && rails_try < 20		# if we're not up to part with rails AND have tried less than 20 times.
							puts "This shift needs Rails help; only at #{self.rails}/#{proficiency_bar} right now. Try #{rails_try}/20"
							rails_try +=1
							if rand_advisor.rails > min_skill
								puts "#{rand_advisor.name} can do Rails: #{rand_advisor.rails}"
								Shift.placeOnShift(rand_advisor, self) 
							else
								puts "XX #{rand_advisor.name} cannot do Rails: only #{rand_advisor.rails}"
							end
						elsif self.angular < proficiency_bar && angular_try < 20	
							puts "This shift needs Angular help; only at #{self.angular}/#{proficiency_bar} right now. Try #{angular_try}/20"
							angular_try +=1
							if rand_advisor.angular > min_skill
								puts "#{rand_advisor.name} can do Angular: #{rand_advisor.angular}"
								Shift.placeOnShift(rand_advisor, self) 
							else
								puts "XX #{rand_advisor.name} cannot do Angular: only #{rand_advisor.php}"
							end
						elsif self.php < proficiency_bar && php_try < 20	
							puts "This shift needs PHP help; only at #{self.php}/#{proficiency_bar} right now. Try #{php_try}/20"
							php_try +=1
							if rand_advisor.php > min_skill
								puts "#{rand_advisor.name} can do PHP: #{rand_advisor.php}"
								Shift.placeOnShift(rand_advisor, self) 
							else
								puts "XX #{rand_advisor.name} cannot do PHP: only #{rand_advisor.php}"
							end
						elsif self.python < proficiency_bar && python_try < 20	
							puts "This shift needs Python help; only at #{self.python}/#{proficiency_bar} right now. Try #{python_try}/20"
							python_try +=1
							if rand_advisor.python > min_skill
								puts "#{rand_advisor.name} can do Python: #{rand_advisor.python}"
								Shift.placeOnShift(rand_advisor, self) 
							else
								puts "XX #{rand_advisor.name} cannot do Python: only #{rand_advisor.python}"
							end
						elsif simple_try <= 20
							"Filling this shift with remaining advisors: try #{simple_try}/20"
							least_scheduled_advisor = Shift.findFewestHours(self.id)
							rand_advisor = least_scheduled_advisor
							Shift.placeOnShift(rand_advisor, self) 
						else
							#if all this fails and we simply can't find good enough advisors to fill the shift, we need to be okay leaving empty slots
							puts "==========we're our of viable advisors. ENDING SEARCH FOR THIS SHIFT============"
							shiftNotFilled = false		# manually override
						end

						if self.advisors.count >= self.advisor_number
							puts "That's all for this one, folks!"
							shiftNotFilled = false 
						end

					end
				end
			end
		end

		puts "DONE! Filled shift # #{self.id} with #{self.advisors.count}/#{self.advisor_number} Advisors"
		puts "ENDING ==================================="

	end


	def self.placeOnShift(advisor, shift)
		puts " ===>> Placing #{advisor.name} on shift on #{shift.start.month}/#{shift.start.day} at #{shift.start.hour}:#{shift.start.min}"
		if advisor.totalHours <= advisor.max_hours						#make sure this advisor is under max hours
			ShiftAssignment.create(advisor_id: advisor.id, shift_id: shift.id, start: shift.start, end: shift.end)
			puts "ADVISOR #{advisor.name} PLACED ON SHIFT!"
			Shift.updateShiftProficiency(shift)
		else
			puts "#{advisor.name} is over hours"
		end
		
	end

	def getLength
		length = (((self.end-self.start).to_i)/60 + 1)/60
		return length
	end

	def self.updateShiftProficiency(s)

		shift = Shift.find(s.id)

		shift.html = 0
		shift.js = 0
		shift.jquery = 0
		shift.angular = 0
		shift.ruby = 0
		shift.rails = 0
		shift.php = 0
		shift.python = 0
		shift.java = 0
		shift.sql = 0
		shift.git = 0
		shift.cmd = 0

		puts "There are currently #{shift.advisors.count} advisors on shift"

		shift.advisors.each do |a|				#cycle through each advisor in shift and add their proficiencies
			puts "adding proficiencies for #{a.name}"
			shift.html 			+= a.html
			shift.js 				+= a.js
			shift.jquery 		+= a.jquery
			shift.angular 	+= a.angular
			shift.ruby 			+= a.ruby
			shift.rails 		+= a.rails
			shift.php 			+= a.php
			shift.python 		+= a.python
			shift.java 			+= a.java
			shift.sql 			+= a.sql
			shift.git 			+= a.git
			shift.cmd 			+= a.cmd	
			shift.save
		end

		puts "Updated proficiency: #{Shift.find(shift.id).getProfs}"


	end

	def getProfs
		return [self.html, self.js, self.jquery, self.angular, self.ruby, self.rails, self.php, self.python, self.java, self.sql, self.git, self.cmd]
	end

	def self.findFewestHours(i)			# we have to somehow identify the shift
		advisors = Advisor.all

		available_advisors = []
		least_scheduled = nil 				# this is the advisor with the fewest hours
		fewest_hours = 99
		this_shift = Shift.find(i)

		advisors.each do |a|											#go through each advisor
			if a.availability[i].to_i == 1 					# if the advisor available on this shift...
				if a.notOnShift?(this_shift)					# check that the advisor isn't on shift...
					available_advisors.push(a) 					# and place into a pool over available advisors
				end
			end
		end

		available_advisors.each do |a|					# take the pool of available advisors
			if a.totalHours < fewest_hours				# if this advisor is working fewer hours than the current max hours
				least_scheduled = a 								# then this is now the least scheduled advisor
				fewest_hours = a.totalHours					# and his/her hours are the fewest hours
			end
		end

		puts "The least scheduled advisor is #{least_scheduled.name}" unless least_scheduled.nil?
		return least_scheduled
	end


end
