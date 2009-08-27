class QuizController < ApplicationController
  
  
  def index
    @main_word = get_new_word
    session[:is_retry] = false
    session[:display_button_der] = true
    session[:display_button_die] = true
    session[:display_button_das] = true
  end
  
  def guess
    #TODO possible optimization? - work directly with german word and article 
    # as parameters, thus avoiding going to the database for the word
    @main_word = Word.find_by_id params[:word_id]
    @missed_word_to_dispaly = nil
    @is_new_word = false
    
    if (@main_word.article == params[:article_guess])
      # Word guesed -> switch to new word
      if session[:is_retry]
        @missed_word_to_dispaly = @main_word
      end
        
      flash[:notice_good] = @main_word.article + ' '+ @main_word.german
      flash[:notice_bad] = nil
        
      @main_word = get_new_word
      @is_new_word = true
      session[:is_retry] = false
      session[:display_button_der] = true
      session[:display_button_die] = true
      session[:display_button_das] = true
    else
      # Wrong guess
      session[:is_retry] = true
      session["display_button_#{params[:article_guess]}".to_sym] = false
    end  
  end
  
private
  def get_new_word
    Word.find(:first, :offset=>(rand Word.count_cache))
  end
end
