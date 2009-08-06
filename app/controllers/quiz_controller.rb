class QuizController < ApplicationController
  def index
    
    generate_new = (session[:last_passed].nil?) || (session[:last_passed])
    
    if generate_new
      offset = rand(Word.count)
      @word = Word.find(:first, :offset => offset)
      session[:word_id] = @word.id
    else
      @word = Word.find(session[:word_id])
    end
    
    if session[:wrong_answers].nil?
      session[:wrong_answers] = {:der => [], :die => [], :das => []}
    end
    
    @wrong_answers = session[:wrong_answers]
    
  end
  
  def guess
    word = Word.find(session[:word_id])
    if (word.article == params[:article])
      
      flash[:notice_good] = word.article + " " + word.german
      
      if (!session[:last_passed].nil?) && (session[:last_passed] == false)
        session[:wrong_answers][word.article.to_sym] << Word.find(session[:word_id])
      end
      
      session[:last_passed] = true
      redirect_to(:action => "index")
      
    else
      
      flash[:notice_bad] = "Try again!"
      session[:last_passed] = false
      
      redirect_to(:action => "index")
      #render_template_part(:template => "/quiz/bad_message")
    end
  end
  
end
