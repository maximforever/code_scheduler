class Shift < ActiveRecord::Base
	has_many :shift_assignments
	has_many :advisors, :through => :shift_assignments

	def self.fill_shift(shift)

			puts "START -----------------------------------"
			shift.advisor_number.times do

				empty_shift = true;

				not_available = true;

				while not_available do 

					updateShiftProficiency(shift)
					rand_advisor = nil
					rand_num = Advisor.count													#pick random advisor
					

					while rand_advisor.nil? do
						rand_advisor = Advisor.find_by_id(Random.rand(rand_num) + 4)
					end

					puts "Found #{rand_advisor.name}"
					
					not_available = false if !Advisor.is_off?(shift, rand_advisor)				# is this advisor available?
					puts "#{rand_advisor.name} can work this shift!" if !not_available	
					if !not_available
					  placeOnShift(rand_advisor, shift)
					end

					if shift.rails < 3
					  placeOnShift(rand_advisor, shift) if rand_advisor.rails > 1
					elsif shift.angular < 3
					  placeOnShift(rand_advisor, shift) if rand_advisor.angular > 1
					elsif shift.python < 3
					  placeOnShift(rand_advisor, shift) if rand_advisor.angular > 1
					elsif shift.php < 3
					  placeOnShift(rand_advisor, shift) if rand_advisor.angular > 1
					end

				end
			end

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

	def self.updateShiftProficiency(shift)

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

		shift.advisors.each do |a|
			shift.html 		+= a.html
			shift.js 		+= a.js
			shift.jquery 	+= a.jquery
			shift.angular 	+= a.angular
			shift.ruby 		+= a.ruby
			shift.rails 	+= a.rails
			shift.php 		+= a.php
			shift.python 	+= a.python
			shift.java 		+= a.java
			shift.sql 		+= a.sql
			shift.git 		+= a.git
			shift.cmd 		+= a.cmd	
		end

	end

	def self.getProfs(shift)
		return [shift.html, shift.js, shift.jquery, shift.angular, shift.ruby, shift.rails, shift.php, shift.python, shift.java, shift.sql, shift.git, shift.cmd]
	end


end
