require 'test_helper'

class MistakeTest < ActiveSupport::TestCase
  def test_belongs_to_user
    assert_equal users(:pixiepal), mistakes(:one).user
    assert_equal users(:globetrotter), mistakes(:two).user
    assert_equal users(:pixiepal), mistakes(:three).user
  end

  def test_belongs_to_word
    assert_equal words(:apfel), mistakes(:one).word
    assert_equal words(:apfel), mistakes(:two).word
    assert_equal words(:college), mistakes(:three).word   
  end

end
