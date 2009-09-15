require 'test_helper'

class QuizControllerTest < ActionController::TestCase
  
  def test_display_fresh_quiz
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:main_word)
    assert assigns(:wrong_button_for) == nil
    assert assigns(:good_button_for) == nil
    assert assigns(:solved_word) == nil
    
    assert_select '#main_word', :count => 1
    assert_select '#link_to_dict', :count => 1
    %w(der die das).each do |article|
      assert_select "##{article}_button.button a", :count => 1
    end
    
    %w(der die das).each do |article|
      %w(wrong good ghost).each do |state|
        assert_select "##{article}_button.#{state} a", false
      end
    end
    
  end
  
  def test_wrong_guess
    # Simulate an AJAX request for pushing the 'die' button on the 'Apfel' word
    # It doesn't metter, what the current word is, we just need to test,
    # what would the system do, if the 'die' button was pressed for the 'Apfel' word
    xml_http_request :get, :guess, :word_id => words(:apfel), :article_guess => 'die'
    assert_response :success
    assert_template :guess
    
    assert assigns(:wrong_button_for) == 'die'
    assert assigns(:good_button_for) == nil
    assert assigns(:solved_word) == nil

    
    xml_http_request :get, :guess, :word_id => words(:apfel), :article_guess => 'das'
    assert_response :success
    assert_template :guess
    
    assert assigns(:wrong_button_for) == 'das'
    assert assigns(:good_button_for) == nil
    assert assigns(:solved_word) == nil
    
    #TODO: Selenium - test the actions resulted from the guess.rjs with Selenium
  end
  
  def test_good_guess_from_first_attempt
    xml_http_request :get, :guess, :word_id => words(:apfel).id, :article_guess => 'der'
    assert_response :success
    assert_template :guess
    
    assert assigns(:good_button_for) == 'der'
    assert assigns(:solved_word) == words(:apfel)
  end
  
  def test_good_guess_from_second_attempt
    xml_http_request :get, :guess, :word_id => words(:ball).id, :article_guess => 'die'
    assert_response :success
    assert_template :guess
    
    assert assigns(:wrong_button_for) == 'die'
    assert assigns(:good_button_for) == nil
    assert assigns(:solved_word) == nil
    
    xml_http_request :get, :guess, :word_id => words(:ball).id, :article_guess => 'der'
    assert_response :success
    assert_template :guess

    
    assert assigns(:good_button_for) == 'der'
    assert assigns(@main_word) != nil
    
    assert assigns(:solved_word) == words(:ball)
  end
  
  def test_summary
    get :index
    assert_equal 0, session[:quiz_counter]
    assert_equal [], session[:mistakes]
    assert_equal false, assigns(:display_summary)
    
    # A simple wrong guess
    xml_http_request :get, :guess, :word_id => words(:ball).id, :article_guess => 'die'
    assert_equal 0, session[:quiz_counter]
    assert_equal mistakes_array([:ball]), session[:mistakes]
    assert_equal false, assigns(:display_summary)
    xml_http_request :get, :guess, :word_id => words(:ball).id, :article_guess => 'der'
    assert_equal 1, session[:quiz_counter]
    assert_equal mistakes_array([:ball]), session[:mistakes]
    assert_equal false, assigns(:display_summary)
    
    # A good guess
    xml_http_request :get, :guess, :word_id => words(:apfel).id, :article_guess => 'der'
    assert_equal 2, session[:quiz_counter]
    assert_equal mistakes_array([:ball]), session[:mistakes].sort
    assert_equal false, assigns(:display_summary)
    
    # A double wrong guess
    xml_http_request :get, :guess, :word_id => words(:college).id, :article_guess => 'der'
    assert_equal 2, session[:quiz_counter]
    assert_equal mistakes_array([:ball, :college]), session[:mistakes].sort
    assert_equal false, assigns(:display_summary)
    xml_http_request :get, :guess, :word_id => words(:college).id, :article_guess => 'die'
    assert_equal 2, session[:quiz_counter]
    assert_equal mistakes_array([:ball, :college]), session[:mistakes].sort
    assert_equal false, assigns(:display_summary)
    xml_http_request :get, :guess, :word_id => words(:college).id, :article_guess => 'das'
    assert_equal 3, session[:quiz_counter]
    assert_equal mistakes_array([:ball, :college]), session[:mistakes].sort
    
    # Another wrong 'der'
    xml_http_request :get, :guess, :word_id => words(:donner).id, :article_guess => 'die'
    assert_equal 3, session[:quiz_counter]
    assert_equal mistakes_array([:ball, :college, :donner]), session[:mistakes]
    assert_equal false, assigns(:display_summary)
    xml_http_request :get, :guess, :word_id => words(:donner).id, :article_guess => 'der'
    assert_equal 4, session[:quiz_counter]
    assert_equal mistakes_array([:ball, :college, :donner]), session[:mistakes]
    assert_equal false, assigns(:display_summary)
    
    # Fill up with good guesses till summary available
    fill_good_count = 6
    fill_good_count.times do
      xml_http_request :get, :guess, :word_id => words(:apfel).id, :article_guess => 'der'
    end
    
    assert assigns(:display_summary)
    assert_response :success
    assert_template :guess
    
    assert !assigns(:summary).nil?
    assert_equal 1 + fill_good_count, assigns(:summary)[:correct_count]
    assert_equal 4 + fill_good_count, assigns(:summary)[:total_count]
    assert_equal "Gut", assigns(:summary)[:sentence]
    assert_equal [words(:ball), words(:donner)].sort, assigns(:summary)[:mistakes][:der].sort
    assert_equal [].sort, assigns(:summary)[:mistakes][:die].sort
    assert_equal [words(:college)].sort, assigns(:summary)[:mistakes][:das].sort
  end
  
private
  def mistakes_array(word_symbols)
    a = word_symbols.collect { |word_symbol| words(word_symbol).id.to_s}
    a.sort
  end
end