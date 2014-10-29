class User < ActiveRecord::Base
  has_many :videos
  has_many :messages   
end


=begin
  

User is created with JSON containing token upon downloading app
User records some video
User is prompted to select a recipient unless the list contains more than "me"

if User skips this option
  User has self as a recipient
  User records the rest of the video
  video gets automatically edited
  gets sent to self as local push notification
  watches the video
  gets sent back to beginning
else given option to add from contacts or search username
  on list of contacts, choose username option shown
    upon selection, input own username
      if username exists (GET), prompted to enter again
      else register user with token (POST)
  if phone contacts
    no need for username
  if search
    show potential recipient (exact match)
      when selecting recipient for first time
        input own username
        if username exists (GET), prompted to enter again
        else register user with token (POST)
      after registration, recipient is selected
      taken to next step automatically
    upon selecting recipient added before, show selection
    take them to next step

User is taken to preview step
User adds music, review continues
User hits a big button to confirm
  exports to album by default
  uploads to S3 simultaneously with export
  upon upload completion, POST video to 






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
