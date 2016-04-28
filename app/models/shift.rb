class Shift < ActiveRecord::Base
	has_many :shift_assignments
	has_many :advisors, :through => :shift_assignments

	def self.fillShift(shift)

			puts "START -----------------------------------"
			shift.advisor_number.times do
				puts "Advisors so far: #{shift.advisors.count}"

				empty_shift = true;
				not_available = true;



				while not_available do
					while (shift.rails < 3 || shift.angular < 3 || shift.python < 3 || shift.php < 3) do

						updateShiftProficiency(shift)
						rand_advisor = nil
						rand_num = Advisor.count													#pick random advisor
						

						while rand_advisor.nil? do
							rand_advisor = Advisor.find_by_id(Random.rand(rand_num) + 4)
						end

						puts "Pulled up #{rand_advisor.name}"
						
						not_available = false if !Advisor.is_off?(shift, rand_advisor)				# is this advisor available?
					end


					puts "#{rand_advisor.name} can work this shift!" if !not_available	
					if !not_available
					  placeOnShift(rand_advisor, shift)
					end

	# =>  THERE IS A PROBLEM IN THE LOGIC HERE - 
	# 	  if the shift is lacking in Rails, and the advisor is not strong in Rails, 
	# 			=> we should move on to the next Advisor?
	# 			=> we should move on to the next skill?

					if shift.rails < 3
						puts "Shift is lacking in Rails. Rails is at #{shift.rails}"
					  if rand_advisor.rails > 1
					  	puts "#{rand_advisor.name} is #{rand_advisor.rails} - Good enough for Rails!"
							placeOnShift(rand_advisor, shift) 
						end
					elsif shift.angular < 3
						puts "Shift is lacking in Angular. Angular is at #{shift.angular}"
					  if rand_advisor.angular > 1 
					  	puts "#{rand_advisor.name} is #{rand_advisor.angular} -  Good enough for Angular!"
					  	placeOnShift(rand_advisor, shift) 
						end
					elsif shift.python < 3
						puts "Shift is lacking in Python. Python is at #{shift.python}"
					  if rand_advisor.python > 1
					  	puts "#{rand_advisor.name} is #{rand_advisor.python} -  Good enough for Python!"
					  	placeOnShift(rand_advisor, shift) 
						end
					elsif shift.php < 3
						puts "Shift is lacking in PHP. PHP is at #{shift.php}"
					  if rand_advisor.php > 1
					  	puts "#{rand_advisor.name} is #{rand_advisor.php} -  Good enough for PHP!"
					  	placeOnShift(rand_advisor, shift) 
					  end
					end


			 end
			end
			
			updateShiftProficiency(shift)
			puts "Total advisors on this shift: #{shift.advisors.count}"
			puts "END -----------------------------------"


	end


	def self.knowsRails(advisor)

	end


	def self.placeOnShift(advisor, shift)
		ShiftAssignment.create(advisor_id: advisor.id, shift_id: shift.id, start: shift.start, end: shift.end)
	end

	def self.getLength(s)
		length = (((s.end-s.start).to_i)/60 + 1)/60
		puts "the length is #{length} hours"
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
			puts "shift html is now at #{shift.html}"
			shift.save
		end

		shift.save


	end

	def self.getProfs(shift)
		return [shift.html, shift.js, shift.jquery, shift.angular, shift.ruby, shift.rails, shift.php, shift.python, shift.java, shift.sql, shift.git, shift.cmd]
	end


end
