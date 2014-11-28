class SNSMessenger

  def initialize
    @sns = AWS::SNS.new
    @platformAppArn = 'arn:aws:sns:us-west-2:503476828113:app/APNS_SANDBOX/CamvyStory'
  end


  def message_original_device(video)
    
    clientResponse = @sns.client.create_platform_endpoint  \
      :platform_application_arn => @platformAppArn,  \
      :token => video.user.token, \
      :custom_user_data => video.user.name
    
    message = {APNS_SANDBOX: {:aps => video.attributes }.to_json}

    begin
      @sns.client.publish \
      :message => message.to_json, \
      :target_arn => clientResponse[:endpoint_arn], \
      :message_structure => 'json'

    rescue AWS::SNS::Errors::EndpointDisabled => e
      #deleted app, clear out device token
      Rails.logger.warn("#{@video.user.name} has disabled token #{@video.token}: #{e.message}")
      @sns.client.delete_endpoint(:endpoint_arn => clientResponse[:endpoint_arn])
   
    rescue AWS::SNS::Errors::InvalidParameter => e
      #means endpoint no longer exists, delete user
      Rails.logger.warn("#{@video.user.name} should be deleted: #{e.message}")
    end
      
      



  end


end