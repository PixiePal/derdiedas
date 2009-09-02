require 'test_helper'

class QuizControllerTest < ActionController::TestCase
  
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
  
  
end
