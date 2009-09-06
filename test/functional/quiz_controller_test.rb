require 'test_helper'

class QuizControllerTest < ActionController::TestCase
  
  def setup
    session[:button_state_der] = :button
    session[:button_state_die] = :button
    session[:button_state_das] = :button
    session[:is_retry] = :false
    session[:good_button_for] = nil
  end
  
  def test_display_fresh_quiz
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:main_word)
    assert session[:is_retry] == false
    assert session[:button_state_der] == :button
    assert session[:button_state_die] == :button
    assert session[:button_state_das] == :button
    
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
    
    assert session[:button_state_der] == :button
    assert session[:button_state_die] == :wrong
    assert session[:button_state_das] == :button
    assert session[:is_retry] == true
    assert session[:good_button_for] == nil
    
    xml_http_request :get, :guess, :word_id => words(:apfel), :article_guess => 'das'
    assert_response :success
    assert_template :guess
    
    assert session[:button_state_der] == :button
    assert session[:button_state_die] == :wrong
    assert session[:button_state_das] == :wrong
    assert session[:is_retry] == true
    assert session[:good_button_for] == nil
    
    #TODO: Selenium - test the actions resulted from the guess.rjs with Selenium
  end
  
  def test_good_guess_from_first_attempt
    xml_http_request :get, :guess, :word_id => words(:apfel), :article_guess => 'der'
    assert_response :success
    assert_template :guess
    
    assert session[:button_state_der] == :button
    assert session[:button_state_die] == :button
    assert session[:button_state_das] == :button
    assert session[:is_retry] == false
    assert session[:good_button_for] == 'der'
  end
  
  def test_good_guess_from_second_attempt
    xml_http_request :get, :guess, :word_id => words(:apfel), :article_guess => 'die'
    assert_response :success
    assert_template :guess
    
    assert session[:button_state_der] == :button
    assert session[:button_state_die] == :wrong
    assert session[:button_state_das] == :button
    assert session[:is_retry] == true
    assert session[:good_button_for] == nil
    
    xml_http_request :get, :guess, :word_id => words(:apfel), :article_guess => 'der'
    assert_response :success
    assert_template :guess

    
    assert session[:good_button_for] == 'der'
  
    # Test that preparations for the next word have been made
    assert session[:button_state_der] == :button
    assert session[:button_state_die] == :button
    assert session[:button_state_das] == :button
    assert session[:is_retry] == false
    
    assert assigns(@main_word) != nil
  end
  
end