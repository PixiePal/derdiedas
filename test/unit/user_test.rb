require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveRecord::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users

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

  def test_should_create_user
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference 'User.count' do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    users(:pixiepal).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:pixiepal), User.authenticate('pixiepal', 'new password')
  end

  def test_should_not_rehash_password
    users(:pixiepal).update_attributes(:login => 'pixiepal2')
    assert_equal users(:pixiepal), User.authenticate('pixiepal2', 'test')
  end

  def test_should_authenticate_user
    assert_equal users(:pixiepal), User.authenticate('pixiepal', 'test')
  end

  def test_should_set_remember_token
    users(:pixiepal).remember_me
    assert_not_nil users(:pixiepal).remember_token
    assert_not_nil users(:pixiepal).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:pixiepal).remember_me
    assert_not_nil users(:pixiepal).remember_token
    users(:pixiepal).forget_me
    assert_nil users(:pixiepal).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    users(:pixiepal).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:pixiepal).remember_token
    assert_not_nil users(:pixiepal).remember_token_expires_at
    assert users(:pixiepal).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    users(:pixiepal).remember_me_until time
    assert_not_nil users(:pixiepal).remember_token
    assert_not_nil users(:pixiepal).remember_token_expires_at
    assert_equal users(:pixiepal).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    users(:pixiepal).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:pixiepal).remember_token
    assert_not_nil users(:pixiepal).remember_token_expires_at
    assert users(:pixiepal).remember_token_expires_at.between?(before, after)
  end

protected
  def create_user(options = {})
    record = User.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    record.save
    record
  end
end
