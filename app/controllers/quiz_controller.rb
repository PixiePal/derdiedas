class QuizController < ApplicationController
  
  def index
    @main_word = get_new_word
  end
  
  def guess
    @main_word = Word.find_by_id params[:word_id]
    if (@main_word.article == params[:article_guess])
      logger.debug "Correct guess #{params[:article_guess]} #{@main_word.german}"
      @good_button_for = @main_word.article
      @solved_word = @main_word
      @main_word = get_new_word
    else
      logger.debug "Wrong guess: #{params[:article_guess]}. " + 
          "Correct would be: #{@main_word.article} #{@main_word.german}"
      @wrong_button_for = "#{params[:article_guess]}"
   end  
  end
  
private
  def get_new_word
    Word.find(:first, :offset=>(rand Word.count_cache))
  end
end
