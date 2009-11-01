class FeedbacksController < ApplicationController
  
  def show
    @feedbacks = Feedback.all
    
  end
  
  def new
    @feedback = Feedback.new
  end
  
  def create
    @feedback = Feedback.new(params[:feedback])
    if @feedback.save
      flash[:notice] = "Thanks for your message!"
      redirect_to new_feedbacks_path
    else
      flash[:error] = "Some fields left empty!"
      render :action => 'new'
    end
  end
  
end
