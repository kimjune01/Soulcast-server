class Video < ActiveRecord::Base
  belongs_to :message

  # validates_presence_of :video_id, :epoch, :user  # Rails 3 way
  validates :video_key, presence: true, uniqueness: true
  validates :epoch,    presence: true
  validates :user_id,  presence: true

  after_create :punch

=begin

@video = Video.find(12)
@video.from 
# => <#User>
@video.from.name

1. when a json request for video comes in, validate presence and uniqueness
2. If valid, save to database, send off request to Elastic Transcoder after_create
3. Put response from Elastic Transcoder into database, jobID.


make SNSController that receives POST JSON from Elastic Transcoder
grab Video for JobID
insert webm and hls fields


Parse push to recipients that have connected via iOS
Parse push to sender if they have non-iOS recipients with a list

A message belongs to one user, has many 




//User is created
//first as a token identifier
//then is prompted to create a username when first attempting to send to an iOS user, no password required.
//username is checked against database to see if it's unique and under 30 characters. 
//PATCH update user to have 
//user data model + static methods
//

//rails needs to know whether the user has the app over iOS or not.
//Whenever push notification is sent to iOS, iOS echos "I'm alive!"
//  to check whether the app has been deleted or not.
//  if the app has been deleted, send push notification to the original sender
	letting them know that the recipient needs to be sent an SMS instead.

//User adds a friend
//  username is unique
//  queries database for a friend that contains the name




=end

  def punch
  	puts "punchy punchy ow ow!"
  end



end
