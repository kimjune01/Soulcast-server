require 'rails_helper'

describe Video do

  before :each do
    @jimmy = User.create name:"jimmy"
    @jimmyVideo = @jimmy.videos.create video_key: "video#{Time.new.inspect}", epoch: 5432345
    
  end

  # it "is valid with a video_key"
  # it "is invalid without a video_key"
  # it "sends a request to AWS before_save"
  # it "receives and saves the job ID upon AWS request"
  # context "when videos are transcoded" do
  #   it "updates its video links"
  #   it "generates a unique video URL link"
  #   it "sends an SNS message to the original device"
  #   it "sends SNS notifications to friends via SNS-APNS"
  # end




  


end