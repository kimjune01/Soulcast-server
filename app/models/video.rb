class Video < ActiveRecord::Base
  belongs_to :message
  belongs_to :user

  # validates :video_key, presence: true, uniqueness: true
  validates :epoch, presence: true
  # validates :user_id,  presence: true
  validates :vanity, uniqueness: true

  def generate_vanity_animal
    animals = File.foreach('app/assets/animals').map { |line| line.split(' ') }
    adjectives = File.foreach('app/assets/adjectives').map { |line| line.split(' ') }
    adjective_adjective_animal = (adjectives.sample + ['-'] + adjectives.sample + ['-'] + animals.sample).join
    self.vanity = adjective_adjective_animal
    if self.save
      return adjective_adjective_animal
    else
      generate_vanity_animal
    end
    
  end

  def to_param
    self.vanity
  end

  def transcode
  	transcoder = Transcoder.new
  	self.jobID = transcoder.transcode(self)
    self.save!
  end

  def webm_link
    return host + self.video_key + '/webm_' + self.video_key
  end

  def hls_link
    hlsPrefix = 'hls_'
    hlsSuffix = '.m3u8'
    return host + self.video_key + '/' + hlsPrefix + self.video_key + hlsSuffix
  end

  def mp4_link
    #https://s3.amazonaws.com/camvybucket/raw/june1416619835.mov
    return 'https://s3.amazonaws.com' + '/camvybucket' '/raw/' + self.video_key + '.mov'
    
  end

  def alt_message_device(message = 'rawr')
    messenger = SNSMessenger.new
  end


  def message_original_device(message = 'rawr')
    message = {APNS_SANDBOX: {:aps => original_device_hash }.to_json}
    #message needs alert!!
    begin
      publishResponse = AWS::SNS.new.client.publish \
      :message => message.to_json, \
      :target_arn => self.user.endpoint_arn, \
      :message_structure => 'json'
    rescue AWS::SNS::Errors::EndpointDisabled => e
      #deleted app, clear out device token
      Rails.logger.warn("#{self.user.name} has disabled token #{self.user.token}: #{e.message}")
      #@sns.client.delete_endpoint(:endpoint_arn => clientResponse[:endpoint_arn])
    rescue AWS::SNS::Errors::InvalidParameter => e
      #means endpoint no longer exists, delete user
      Rails.logger.warn("#{self.user.name} should be deleted: #{e.message}")
    end
  end

  def message_recipient_device(message = 'rawr')
    @recipient = User.find_by(phone: self.recipient)
    #hash = {:video => self.attributes, :sender => self.user.attributes, :alert => "Someone sent you a message!", :sound => 'default'}
    message = {APNS_SANDBOX: {:aps => recipient_hash }.to_json}
    
    begin
      publishResponse = AWS::SNS.new.client.publish \
      :message => message.to_json, \
      :target_arn => @recipient.endpoint_arn, \
      :message_structure => 'json'
    rescue AWS::SNS::Errors::EndpointDisabled => e
      #deleted app, clear out device token
      Rails.logger.warn("#{@recipient.name} has disabled token #{self.user.token}: #{e.message}")
      #@sns.client.delete_endpoint(:endpoint_arn => clientResponse[:endpoint_arn])
    rescue AWS::SNS::Errors::InvalidParameter => e
      #means endpoint no longer exists, delete user
      Rails.logger.warn("#{@recipient.name} should be deleted: #{e.message}")
    end
  end

  def recipient_hash
    {:video => self.attributes, :sender => self.user.attributes, :alert => "Someone sent you a message!", :sound => 'default'}
  end

  def original_device_hash
     {:video => self.attributes, :origin => 'self', :alert => "Send the message to your friends!", :sound => 'default'}
  end

  def host
    'https://s3-' + Global.all.region + '.amazonaws.com' + '/' + Global.all.output_bucket + '/' + Global.all.pipeline_name + '/'
  end

end
