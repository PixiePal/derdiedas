require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_has_many_mistakes
    assert_equal [mistakes(:one), mistakes(:three)], users(:pixiepal).mistakes
    assert_equal [mistakes(:two)], users(:globetrotter).mistakes
    assert_equal [], users(:newbie).mistakes
  end
end
