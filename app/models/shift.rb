class Shift < ActiveRecord::Base
	has_many :shift_assignments
	has_many :advisors, :through => :shift_assignments



	def self.fillAllShifts						# the nuclear option
		all_shifts = Shift.all

		all_shifts.each do |shift|			
			shift.fill_shift
		end
	end

	def self.fillVacations
		Vacation.all.each do |v|
			a = Advisor.find_by_name(v.name)
			v.advisor_id = a.id unless a.nil?
			v.save
		end
	end



#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------------------------------



def fill_shift

		puts "STARTING for shift #{self.id} ===================="
		
		
		shift_filled = false

		max_tries 			= 20
		rails_try			= 0
		angular_try			= 0
		php_try				= 0
		python_try			= 0
		general_try 		= 0

		until(self.advisors.count >= self.advisor_number || shift_filled) do				# we keep searching until we hit the number of advisors we need OR manually fill the shift
			puts "There are currently advisors #{self.advisors.count}/#{self.advisor_number} on shift"
			if (self.rails < 1 && rails_try < max_tries)
				puts "Looking for a RAILS advisor, try #{rails_try}"
				rails_try += 1
				fill_with_language("rails")
			elsif (self.angular < 1 && angular_try < max_tries)
				puts "Looking for a ANGULAR advisor, try #{angular_try}"
				angular_try += 1
				fill_with_language("angular")
			elsif (self.php < 1&& php_try < max_tries)
				puts "Looking for a PHP advisor, try #{php_try}"
				php_try += 1
				fill_with_language("php")
			elsif (self.python < 1&& python_try < max_tries)
				puts "Looking for a PYTHON advisor, try #{python_try}"
				python_try += 1
				fill_with_language("python")
			elsif (general_try < max_tries)
				puts "looking for a GENERAL advisor, try #{general_try}"
				general_try += 1
				fill_with_language("general")
			else
				puts "That's all, folks! We tried rails #{rails_try} times, angular #{angular_try} times, php  #{php_try} times, python #{python_try} times."
				shift_filled = true
			end

		end	
		
		puts "ENDING ===================="


	end



	def fill_with_language(lang)					# this method finds the least scheduled available advisor who knows the input language

		minimum_proficiency = 2
		languages = ["rails", "angular", "php", "python", "general"]

		if languages.include?(lang) 																					# make sure this is a real language
			
			if (lang == "general")
				puts "grabbing a general advisor"
				eligible = Advisor.all
			else
				puts "grabbing a specialized advisor"
				eligible = Advisor.where("#{lang} > ?", minimum_proficiency)											# grab all the advisors that can support this language		
			end

			available = []																											# clear available advisors

			eligible.each do |a|																								# get all the available advisors from eligible advisors
				if a.available?(self) && a.notOnShift?(self)
					available.push(a)
				end		
			end

			available.shuffle!

			if available.length > 0		# if there are any advisors who can do the language AND are available
				"Some #{lang} advisors are available"
				# now we have all the available advisors who can also do this language
				# we want to pick the advisor with fewest hours this week

				least_scheduled_advisor = nil
				least_hours = 999

				available.each do |av|
					advisor_hours = av.totalHours

					if advisor_hours < least_hours				# if this advisor has fewer hours this week than the least scheduled advisor, than this is the new least scheduled advisor
						least_hours = advisor_hours
						least_scheduled_advisor = av
					end
				end



				Shift.placeOnShift(least_scheduled_advisor, self, lang)			# place the least scheduled advisor who knows this language on shift
			else
				"Nobody that can do #{lang} is available"
			end

		else
			puts "#{lang} is not a valid language"
		end
	end

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	

	def self.placeOnShift(advisor, shift, position)

		case position
			when "rails"
				shift.rails = 1
			when "angular"
				shift.angular = 1
			when "php"
				shift.php = 1
			when "python"
				shift.python = 1
		end

		shift.save


		puts " ===>> Placing #{advisor.name} on shift on #{shift.start.month}/#{shift.start.day} at #{shift.start.hour}:#{shift.start.min}"
		if advisor.totalHours <= advisor.max_hours						#make sure this advisor is under max hours
			s = ShiftAssignment.create(advisor_id: advisor.id, shift_id: shift.id, start: shift.start, end: shift.end, position: position)
			puts "ADVISOR #{advisor.name} PLACED ON SHIFT for #{s.position}!"
		else
			puts "#{advisor.name} is over hours"
		end
		
	end

=begin


	def fillShift

		puts "STARTING ==================================="
		puts "There are currently advisors #{self.advisors.count}/#{self.advisor_number} on shift"

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

						if self.rails < 1 && rails_try < 20		# if we're not up to par with rails AND have tried less than 20 times.
							puts "This shift needs Rails help. Try #{rails_try}/20"
							rails_try +=1
							if rand_advisor.rails > min_skill
								puts "#{rand_advisor.name} can do Rails: #{rand_advisor.rails}"
								Shift.placeOnShift(rand_advisor, self, "rails") 
								self.rails = 1
								self.save
							else
								puts "XX #{rand_advisor.name} cannot do Rails: only #{rand_advisor.rails}"
							end
						elsif self.angular < 1 && angular_try < 20	
							puts "This shift needs Angular help. Try #{angular_try}/20"
							angular_try +=1
							if rand_advisor.angular > min_skill
								puts "#{rand_advisor.name} can do Angular: #{rand_advisor.angular}"
								Shift.placeOnShift(rand_advisor, self, "angular") 
								self.angular = 1
								self.save
							else
								puts "XX #{rand_advisor.name} cannot do Angular: only #{rand_advisor.php}"
							end
						elsif self.php < 1 && php_try < 20	
							puts "This shift needs PHP help. Try #{php_try}/20"
							php_try +=1
							if rand_advisor.php > min_skill
								puts "#{rand_advisor.name} can do PHP: #{rand_advisor.php}"
								Shift.placeOnShift(rand_advisor, self, "php") 
								self.php = 1
								self.save
							else
								puts "XX #{rand_advisor.name} cannot do PHP: only #{rand_advisor.php}"
							end
						elsif self.python < 1 && python_try < 20	
							puts "This shift needs Python help. Try #{python_try}/20"
							python_try +=1
							if rand_advisor.python > min_skill
								puts "#{rand_advisor.name} can do Python: #{rand_advisor.python}"
								Shift.placeOnShift(rand_advisor, self, "python") 
								self.python = 1
								self.save
							else
								puts "XX #{rand_advisor.name} cannot do Python: only #{rand_advisor.python}"
							end
						elsif simple_try <= 20
							"Filling this shift with remaining advisors: try #{simple_try}/20"
							least_scheduled_advisor = Shift.findFewestHours(self.id)
							rand_advisor = least_scheduled_advisor
							Shift.placeOnShift(rand_advisor, self, "general") 
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
=end


	def getLength
		length = (((self.end-self.start).to_i)/60 + 1)/60
		return length
	end

	def self.updateShiftProficiency(s)				# this method might be useless
		shift = Shift.find(s.id)
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
