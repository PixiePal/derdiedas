require 'test_helper'

class MistakeTest < ActiveSupport::TestCase
  def test_belongs_to_user
    assert_equals users(:pixiepal), mistakes(:one).user
    assert_equals users(:globetrotter).to_set, [mistakes(:two).user, mistakes(:three).user].to_set
  end

  def test_belongs_to_word
    assert_equals users(:pixiepal), mistakes(:one).user
    assert_equals users(:globetrotter).to_set, [mistakes(:two).user, mistakes(:three).user].to_set
  end

end
