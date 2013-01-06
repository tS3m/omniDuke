class InstructorReviewsController < ApplicationController
  def new
  	@review = InstructorReview.new
  	@instructor_id = params[:instructor_id]
  end


  def create
  	areview = Instructor.new(params[:course_review])
    if areview.save
      flash[:success] = "Review created!"
      redirect_to root_path
    else
    	flash[:error] = "review not created!"
      redirect_to :action => :new
    end
  end
end
