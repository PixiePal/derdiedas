class QuizController < ApplicationController
  
  
  def index
    @main_word = get_new_word
    session[:is_retry] = false
  end
  
  def guess
    #TODO possible obtimization? - work directly with german word and article 
    # as parameters, thus avoiding going to the database for the word
    @main_word = Word.find_by_id params[:word_id]
    @missed_word_to_dispaly = nil
    @is_new_word = false
    
    if (@main_word.article == params[:article_guess])
        if session[:is_retry]
          @missed_word_to_dispaly = @main_word
        end
        
        flash[:notice_good] = @main_word.article + ' '+ @main_word.german
        flash[:notice_bad] = nil
        
        @main_word = get_new_word
        @is_new_word = true
        session[:is_retry] = false
    else
        session[:is_retry] = true
        flash[:notice_bad] = 'Try again!'
        flash[:notice_good] = nil
    end  
  end
  
private
  def get_new_word
    Word.find(:first, :offset=>(rand Word.count_cache))
  end
end
