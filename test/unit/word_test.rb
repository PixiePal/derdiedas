require 'test_helper'

class WordTest < ActiveSupport::TestCase
  def test_has_many_mistakes
    assert_equal [mistakes(:one), mistakes(:two)].to_set, words(:apfel).mistakes.to_set
    assert_equal [], words(:ball).mistakes
    assert_equal [mistakes(:three)], words(:college).mistakes
    assert_equal [], words(:donner).mistakes
  end
  
  def test_has_many_correct_answers
    assert_equal [], words(:apfel).correct_answers
    assert_equal [correct_answers(:one), correct_answers(:three)].to_set, words(:ball).correct_answers.to_set
    assert_equal [], words(:college).correct_answers
    assert_equal [correct_answers(:two)], words(:donner).correct_answers
  end
end
