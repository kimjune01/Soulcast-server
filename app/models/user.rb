class User < ActiveRecord::Base
  has_many :videos
  #has_many :sent_messages, foreign_key: :from_id, class_name: 'Message'
  #has_many :received_messages, foreign_key: :to_id, class_name: 'Message'
end



