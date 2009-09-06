require 'test_helper'

class QuizControllerTest < ActionController::TestCase
  
  def setup
    session[:button_state_der] = :button
    session[:button_state_die] = :button
    session[:button_state_das] = :button
    session[:is_retry] = :false
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
  end
  
  def test_wrong_guess
    # Simulate an AJAX request for pushing the 'die' button on the 'Apfel' word
    # It doesn't metter, what the current word is, we just need to test,
    # what would the system do, if the 'die' button was pressed for the 'Apfel' word
    xml_http_request :get, :guess, :word_id => words(:apfel), :article_guess => :die
    assert_response :success
    
    assert session[:button_state_der] == :button
    assert session[:button_state_die] == :wrong
    assert session[:button_state_das] == :button
    assert session[:is_retry] == true
    
    xml_http_request :get, :guess, :word_id => words(:apfel), :article_guess => :das
    assert_response :success
    
    assert session[:button_state_der] == :button
    assert session[:button_state_die] == :wrong
    assert session[:button_state_das] == :wrong
    assert session[:is_retry] == true
    
    #xml_http_request :get, :guess, :word_id => words(:apfel), :article_guess => :der
    #assert_rjs :visual_effect, :fade, :_main_word
  end
  
end