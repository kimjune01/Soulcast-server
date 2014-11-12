require 'rails_helper'

describe Api::VideosController do
  before :each do
    Video.destroy_all
    User.destroy_all
    @jimmy = User.create name:"shimmy#{Time.new.inspect}", token: '79b149183b7292bf0e609812ef2a8ceb67a0fa785e00dd017131389b2b61f9e2'
    @jimmyVideo = @jimmy.videos.create video_key: "video#{Time.new.inspect}", epoch: 5432345 , webm: "http://www.webm.com", hls: "http://www.hls.com"
    @sns = AWS::SNS.new
    @platformAppArn = 'arn:aws:sns:us-west-2:503476828113:app/APNS_SANDBOX/CamvySup'
    
  end

  it 'saves a job ID when requesting a transcode request' do
    expect(@jimmyVideo.jobID).not_to eql(nil) 
  end

  it 'finds a video by jobID' do
    expect(@jimmyVideo).to eq(Video.find_by(jobID: @jimmyVideo.jobID))
  end

  context '#catch: when a video is done transcoding' do
    it 'saves the WebM and HLS links when transcoding successful' do
      @request.env['HTTP_X_AMZ_SNS_MESSAGE_TYPE'] = 'Notification'
      @request.env['HTTP_X_AMZ_SNS_TOPIC_ARN'] = 'arn:aws:sns:us-west-2'
      @request.env['RAW_POST_DATA'] = {}.to_json
      expect_any_instance_of(Api::VideosController).to receive(:get_sns_subject).and_return("transcoder")
      expect_any_instance_of(Api::VideosController).to receive(:get_sns_message).and_return({'state' => 'COMPLETED', 'jobId' => @jimmyVideo.jobID})
      post :catch
      #request comes in here
      video = controller.instance_variable_get(:@video)
      expect(video.transcoded).to eq(true)
      # expect(video.webm).to eq("https://s3-us-west-2.amazonaws.com/supman/kinder/webm_june0008")
      end
  end


  it 'makes a new topic when sending a new message' do
    initialTopics = @sns.topics
    initialTopicsCount = initialTopics.page(:per_page => 100).size
    shimmyTopic = initialTopics.create('rspecTopic')
    afterTopics = @sns.topics
    afterTopicsCount = afterTopics.page(:per_page => 100).size
    shimmyTopic.delete
    expect(afterTopicsCount).to eq(initialTopicsCount + 1)
    
  end

  context 'when a topic exists, SNS' do

    before :all do @jimmyTopic = @sns.topics.create('jimmyTopic') end
    after :all do @jimmyTopic.delete end



    it 'sends a message to a device token' do
      #check if device token is nil
      if @jimmy.token == nil
        Rails.logger.warn('Token is nil, this user has deleted the app')

      end

      clientResponse = @sns.client.create_platform_endpoint  \
        :platform_application_arn => @platformAppArn,  \
        :token => @jimmy.token, \
        :custom_user_data => @jimmy.name
      
      message = {APNS_SANDBOX: {:aps => { "webm" => @jimmyVideo.webm, "hls" => @jimmyVideo.hls }}.to_json}
      begin
        @sns.client.publish \
        :message => message.to_json, \
        :target_arn => clientResponse[:endpoint_arn], \
        :message_structure => 'json'

      rescue AWS::SNS::Errors::EndpointDisabled => e
        #deleted app, clear out device token
        Rails.logger.warn("#{@jimmy.name} has disabled token #{@jimmy.token}: #{e.message}")
        @sns.client.delete_endpoint(:endpoint_arn => clientResponse[:endpoint_arn])
     
      rescue AWS::SNS::Errors::InvalidParameter => e
        #means endpoint no longer exists, delete user
        Rails.logger.warn("#{@jimmy.name} should be deleted: #{e.message}")
      end
      
          # it 'subscribes chickenJuice to the topic' do
    #   initialJimmySubscriptionsCount = @jimmyTopic.subscriptions.page(:per_page => 100).size
    #   @jimmyTopic.subscribe('http://chickenjuice.t.proxylocal.com/api/sns')
    #   afterJimmySubscriptionsCount = @jimmyTopic.subscriptions.page(:per_page => 100).size
      
    #   expect(afterJimmySubscriptionsCount).to eq(initialJimmySubscriptionsCount+1)
    # end

    # it 'publishes to a topic' do
    #   kinderSurprised = @sns.topics['arn:aws:sns:us-west-2:503476828113:kindersurprised']
    #   subject = 'rspec subject'
    #   message = "rspec message"
    #   apnsMessage = 'apns message'
    #   kinderSurprised.publish( message, :subject => subject)
    # end

    end

  end

end