require 'test_helper'

class CorrectAnswerTest < ActiveSupport::TestCase
  def test_belongs_to_user
    assert_equal users(:pixiepal), correct_answers(:one).user
    assert_equal users(:globetrotter), correct_answers(:two).user
    assert_equal users(:globetrotter), correct_answers(:three).user
  end

  def test_belongs_to_word
    assert_equal words(:ball), correct_answers(:one).word
    assert_equal words(:donner), correct_answers(:two).word
    assert_equal words(:ball), correct_answers(:three).word   
  end
end
