class Shift < ActiveRecord::Base
	has_many :shift_assignments
	has_many :advisors, :through => :shift_assignments



	def self.fillAllShifts						# the nuclear option
		all_shifts = Shift.all

		all_shifts.each do |shift|			
			shift.fillShift
		end


	end



	def fillShift

		puts "STARTING ==================================="
		puts "There are currently advisors #{self.advisors.count}/#{self.advisor_number} on shift"

		proficiency_bar = 3				# this is pretty important - how much proficiency (max 5 per advisor) do we want for our courses?

		rails_try = 0							# we reset how many times we're going to try to fill each of these courses
		angular_try = 0
		python_try = 0
		php_try = 0
		simple_try = 0

		shiftNotFilled = true


		while(shiftNotFilled)		#while the shift hasn't been manually filled [cause we're out of adviors] OR we've filled it completely [with good advisors]

			if (self.advisors.count < self.advisor_number)
				rand_advisor = nil
				rand_num = Advisor.count + 82						#pick a number between 0 and the number of Advisors

				while rand_advisor.nil? do								#keep picking an advisor at random until you get one that's not nil
					rand_advisor = Advisor.find_by_id(Random.rand(rand_num))
				end


				if rand_advisor.available?(self)					# check that advisor is available
					if rand_advisor.notOnShift?(self)				# check that advisor isn't already on shift

						puts "Proficiency tries: Rails: #{rails_try}, Angular: #{angular_try}, Python: #{python_try}, PHP: #{php_try}"

						this_shift = Shift.find(self.id)

						if this_shift.rails >= proficiency_bar || rails_try >= 20
							puts "Rails OK!"
							puts "Out of Rails tries" if rails_try >= 20
							if this_shift.angular >= proficiency_bar || angular_try >= 20
								puts "Angular OK!"
								puts "Out of Angular tries" if angular_try >= 20
								if this_shift.python >= proficiency_bar || python_try >= 20
									puts "Python OK!"
									puts "Out of Python tries" if python_try >= 20
										if this_shift.php >= proficiency_bar || php_try >=20
											puts "PHP OK!"
											puts "Out of PHP tries" if php_try >= 20
												if simple_try <= 20
													"Filling this shift with remaining advisors: try #{simple_try}/20"
													Shift.placeOnShift(rand_advisor, self) 
												else
													#if all this fails and we simply can't find good enough advisors to fill the shift, we need to be okay leaving empty slots
													puts "==========we're our of viable advisors. SHUTTING DOWN============"
													shiftNotFilled = false		# manually override
												end
										else 
											puts "This shift needs PHP help; only at #{this_shift.php}/#{proficiency_bar} right now. Try #{php_try}/20"
											if rand_advisor.php > 2
												puts "#{rand_advisor.name} can do PHP: #{rand_advisor.php}"
												Shift.placeOnShift(rand_advisor, self) 
											else
												php_try +=1
											end
										end
								else
									puts "This shift needs Python help; only at #{this_shift.python}/#{proficiency_bar} right now. Try #{python_try}/20"
									if rand_advisor.python > 2
										puts "#{rand_advisor.name} can do Python: #{rand_advisor.python}"
										Shift.placeOnShift(rand_advisor, self) 
									else
										python_try += 1
									end
								end
							else
								puts "This shift needs Angular help; only at #{this_shift.angular}/#{proficiency_bar} right now. Try #{angular_try}/20"
								if rand_advisor.angular > 2
									puts "#{rand_advisor.name} can do Angular: #{rand_advisor.angular}"
									Shift.placeOnShift(rand_advisor, self) 
								else
									angular_try += 2
								end
							end
						else
							puts "This shift needs Rails help; only at #{this_shift.rails}/#{proficiency_bar} right now. Try #{rails_try}/20"
							if rand_advisor.rails > 1
								puts "#{rand_advisor.name} can do Rails: #{rand_advisor.rails}"
								Shift.placeOnShift(rand_advisor, self) 
							else
								rails_try += 1
							end
						end
					end
				end

				

			else
				shiftNotFilled = false				# if we've filled the shift and self.advisors.count >= self.advisor_number, we're done!
			end
		end

		puts "DONE! Filled shift # #{self.id} with #{self.advisors.count}/#{self.advisor_number} Advisors"
		puts "ENDING ==================================="

	end


	def self.placeOnShift(advisor, shift)
		if advisor.totalHours <= advisor.max_hours
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


end
