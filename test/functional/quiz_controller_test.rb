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
  
end