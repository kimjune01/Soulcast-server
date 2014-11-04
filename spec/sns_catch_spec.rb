RSpec.describe "SNS-Catch", :type => :request do
  it "returns a job ID when requesting a transcode request" do
  	jimmy = User.new 
  	jimmy.name = "jimmy"
  	jimmy.save

  	lol = jimmy.videos.create video_key: "video#{Time.new.inspect}", epoch: 5432345
  	expect(lol.jobID).not_to eql(nil) 
  end
end
