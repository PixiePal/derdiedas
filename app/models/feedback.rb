class Feedback < ActiveRecord::Base
  attr_accessible :name, :email, :message
  validates_presence_of :email, :message
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
end
