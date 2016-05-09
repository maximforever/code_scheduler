class ShiftsController < ApplicationController
  
  def index
    @all_shifts = ShiftAssignment.all.order(start: :asc)
  end

  def shifts
    @all_shifts = Shift.all
    @advisors = Advisor.all
  end

end
