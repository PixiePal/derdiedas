require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_has_many_mistakes
    assert_equal [mistakes(:one), mistakes(:three)].to_set, users(:pixiepal).mistakes.to_set
    assert_equal [mistakes(:two)], users(:globetrotter).mistakes
    assert_equal [], users(:newbie).mistakes
  end
  
  def test_has_many_correct_answers
    assert_equal [correct_answers(:one)], users(:pixiepal).correct_answers
    assert_equal [correct_answers(:two), correct_answers(:three)].to_set, users(:globetrotter).correct_answers.to_set
    assert_equal [], users(:newbie).correct_answers
  end
end
