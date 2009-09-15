class QuizController < ApplicationController
  
  def index
    @main_word = get_new_word
    session[:quiz_counter] = 0
    session[:mistakes] = []
    @display_summary = false
  end
  
  def guess
    @main_word = Word.find_by_id params[:word_id]
    if (@main_word.article == params[:article_guess])
      logger.debug "Correct guess #{params[:article_guess]} #{@main_word.german}"
      @good_button_for = @main_word.article
      @solved_word = @main_word
      @main_word = get_new_word
      session[:quiz_counter].nil? ? session[:quiz_counter] = 1 : session[:quiz_counter] += 1
      if session[:quiz_counter] == 10
        @display_summary = true
        @summary = prepare_quiz_summary
      end
    else
      logger.debug "Wrong guess: #{params[:article_guess]}. " + 
          "Correct would be: #{@main_word.article} #{@main_word.german}"
      @wrong_button_for = "#{params[:article_guess]}"
      session[:mistakes].nil? ? session[:mistakes] = [] : session[:mistakes] << params[:word_id]
      session[:mistakes].uniq!
   end
  end
  
private
  def get_new_word
    Word.find(:first, :offset=>(rand Word.count_cache))
  end
  
  def prepare_quiz_summary
    summary = {}
    summary[:correct_count] = session[:quiz_counter] - session[:mistakes].size
    summary[:total_count] = session[:quiz_counter]
    summary[:mistakes] = {:der => [], :das => [], :die => [],}
    mistakes = Word.find_all_by_id session[:mistakes]
    mistakes.each {|word| summary[:mistakes][word.article.to_sym] << word}
    summary[:sentence] = prepare_sentence summary[:total_count], summary[:correct_count]
    summary
  end
  
  def prepare_sentence(total, correct)
    percent = (correct * 100) / total
    case percent
    when 90..100
      "Ausgezeichnet"
    when 80..89
      "Sehr gut"
    when 70..79
      "Gut"  
    when 50..69
      "Mittelmäßig"
    when 0..49
      "Zu verbessern"
    end
  end
end
