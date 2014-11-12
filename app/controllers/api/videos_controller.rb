require 'pry'
class Api::VideosController < ApplicationController
 protect_from_forgery :except => :catch 
 before_filter :respond_to_aws_sns_subscription_confirmations, only: [:create]
	# POST /users
  # POST /users.json
  def index
    @allVideos = Video.all
    puts @allVideos.size
    render json: @allVideos
  end


  def create
    @video = Video.new(video_params)

    respond_to do |format|
      if @video.save
        @video.transcode
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def video_params
    params.require(:video).permit(:video_id, :epoch, :user, :vanity, :hls, :webm, :title, :public_shared, :transcoded);
  end

  def catch
    snsRequest = request
    # binding.pry
    if snsRequest.headers['HTTP_X_AMZ_SNS_MESSAGE_TYPE'] == 'Notification'
      if snsRequest.headers['HTTP_X_AMZ_SNS_TOPIC_ARN'].include? 'arn:aws:sns:us-west-2'
        snsBody = JSON.parse(snsRequest.body.read)
        snsMessage = get_sns_message(snsBody)
        if get_sns_subject(snsBody).downcase.include? 'transcoder'
          videoDidTranscode(snsMessage)
        end
      end
    end
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  def get_sns_message(snsBody)
    JSON.parse(snsBody["Message"])
  end

  def get_sns_subject(snsBody)
    snsBody['Subject']
  end

  def videoDidTranscode (snsMessage)
    
    if snsMessage['state'] == "ERROR"

      handle(snsMessage['outputs'].first['errorCode'])
    elsif snsMessage['state'] == "COMPLETED"
      puts "Transcoding successful!"
      #write a test for green path
      #find video by jobID
      
      @video = Video.find_by jobID: snsMessage['jobId']
      #assign its transcoded to true

      @video.mark_as_transcoded!
      # all the work below and calls save!


      # messenger = SNSMessenger.new
      # messenger.messageOriginalDevice(video)
      
      # binding.pry


    end
  end

  def sendSNS
    snsClient = AWS::SNS.new
    #make a topic
    arn = 
    snsTopic = AWS::SNS::Topic.initialize()
    #subscribe #subscribe to topic
    #publish to topic
    #unsubscribe #subscribe from topic
    #remove topic
    
  end

  def subscribe
    @subscribeRequest = request
    amz_message_type = @subscribeRequest.headers['x-amz-sns-message-type']
    amz_sns_topic = @subscribeRequest.headers['x-amz-sns-topic-arn']
    return unless !amz_sns_topic.nil?
    request_body = JSON.parse request.body.read
    if amz_message_type.to_s.downcase == 'subscriptionconfirmation'
       send_subscription_confirmation request.body
       return
    end

  end

  def send_subscription_confirmation(request_body)
    subscribe_url = request_body['SubscribeURL']
    return nil unless !subscribe_url.to_s.empty? && !subscribe_url.nil?
    subscribe_confirm = HTTParty.get subscribe_url
  end

  def handle(errorCode)
    case errorCode
        when 1000
          puts 'Validation Error'
        when 2000
          puts 'Cannot Assume Role'
        when 3000
          puts 'Unclassified Storage Error'
        when 3001
          puts 'Input Does Not Exist'
        when 3002
          puts 'Output Already Exists'
        when 3003
          puts 'IAM role Does Not Have Read Permission'
        when 3004
          puts 'IAM role Does Not Have Write Permission'
        when 4000..4104
          puts 'Bad Input File'
        when 9000..9999
          puts 'Internal Service Error'
        else
          puts 'errorCode is not nil??'
        end
        puts errorCode

  end


end
