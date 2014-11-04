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
    # TODO: validate incoming POST 
    binding.pry
    @snsMessage = request
    if @snsMessage.headers['HTTP_X_AMZ_SNS_MESSAGE_TYPE'] == "Notification"
      puts "Incoming message is has a notification header"
      puts JSON.parse(@snsMessage.body.read)["Message"]
      puts JSON.parse(JSON.parse(@snsMessage.body.read)["Message"])["messageDetails"]
      
      
    end
    #   headers, message's subject contains Amazon Elastic Transcoder
    #   check
    #   status is completed OR failed
    #   if green, find video by job ID
    #   
    # TODO: handle exceptions thrown by JSON.parse
    # TODO: find video object via job ID
    # @video = Video.find_by jobID: JSON.parse(request_body)[""]
    # TODO: change 
    # TODO: call method to send a message back to the OGD
    render @snsMessage

    # if request.headers['x-amz-sns-message-type'] == 'subscriptionconfirmation'
    #   subscribe_url = request_body['SubscribeURL']
    #   return nil unless !subscribe_url.to_s.empty? && !subscribe_url.nil?
    #   subscribe_confirm = HTTParty.get subscribe_url
    # end

    # if request.headers['x-amz-sns-message-type'] == 'Notification'
    #   puts request.body
    # end

    # puts 'OH NOES THE MESSAGE TYPE IS OFF! :' + request.headers['x-amz-sns-message-type']
    
  end

end
