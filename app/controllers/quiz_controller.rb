class QuizController < ApplicationController
  
  def index
    @main_word = get_new_word
    session[:is_retry] = false
    session[:button_state_der] = :button
    session[:button_state_die] = :button
    session[:button_state_das] = :button
    session[:good_button_for] = nil
  end
  
  def guess
    @main_word = Word.find_by_id params[:word_id]
    @missed_word_to_dispaly = nil
    @is_new_word = false
    
    if (@main_word.article == params[:article_guess])
      logger.debug "Correct guess #{params[:article_guess]} #{@main_word.german}"
      
      # Word guesed -> switch to new word
      session[:good_button_for] = @main_word.article
      
      if session[:is_retry]
        @missed_word_to_dispaly = @main_word
      end
        
      @main_word = get_new_word
      @is_new_word = true
      session[:is_retry] = false
      session[:button_state_der] = :button
      session[:button_state_die] = :button
      session[:button_state_das] = :button
    else
      logger.debug "Wrong guess: #{params[:article_guess]}. Correct would be: #{@main_word.article} #{@main_word.german}"
      session[:is_retry] = true
      session[:good_button_for] = nil
      session["button_state_#{params[:article_guess]}".to_sym] = :wrong
    end  
  end
  
private
  def get_new_word
    Word.find(:first, :offset=>(rand Word.count_cache))
  end
end
