class Message < ActiveRecord::Base
  has_one :video
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'

  validates_presence_of :video, :user

end
