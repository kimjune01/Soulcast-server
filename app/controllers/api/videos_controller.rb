require 'pry'
class Api::VideosController < ApplicationController
 protect_from_forgery :except => :catch 
 before_filter :respond_to_aws_sns_subscription_confirmations, only: [:create]
	
  def index
    @allVideos = Video.all
    puts @allVideos.size
    render json: @allVideos
  end


  def create
    #read the token, find user by token
    @user = User.find_by(token: user_params[:token])
    if @user
      @video = @user.videos.create(video_params)
    else 
      # @user = User.last
      # @video = @user.videos.create(video_params)
      @user = User.new(phone: '1111111111', token: user_params[:token])
      puts 'could not create: token not found'
      render json: {:error => 'could not create: token not found'}
    end
    @recipient = User.find_by(phone: params[:video][:recipient_phone].split(//).last(10).join)
    if @recipient && @recipient.is_on_camvy
      @video.via = :apns
    else
      @video.via = :sns
    end

    @video.recipient = params[:video][:recipient_phone]
    @video.generate_vanity_animal
    
    if @video.save
      @video.transcode
      render json: @video
    else
      render json: {error => 'could not save'}
    end
  end

  def user_params
    params.require(:video).permit(:token)
  end

  def video_params
    params.require(:video).permit(:video_key, :epoch, :user, :vanity, :hls, :webm, :title, :public_shared, :transcoded);
  end

  def catch
    snsRequest = request
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
    @video = Video.find_by jobID: snsMessage['jobId']
    puts snsMessage['state']
    if snsMessage['state'] == "ERROR"
      handle(snsMessage['outputs'].first['errorCode'])
      @video.message_original_device("transcoding error: #{snsMessage['outputs'].first['errorCode']}")
      
    elsif snsMessage['state'] == "COMPLETED"
      puts "Transcoding successful!"   
      @video = Video.find_by jobID: snsMessage['jobId']
      @video.transcoded = true
      @video.hls = @video.hls_link
      #@video.webm???

      @video.save!
      # all the work below and calls save!
      if @video.via == 'sns'
        @video.message_original_device('transcoding completed')
      end
      if  @video.via == 'apns'
        @video.message_recipient_device('transcoding completed')
      end
      
    end
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
