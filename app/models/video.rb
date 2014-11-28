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
    return host + hlsPrefix + self.video_key + hlsSuffix
  end

  def mp4_link
    #https://s3.amazonaws.com/camvybucket/raw/june1416619835.mov
    return 'https://s3.amazonaws.com' + '/camvybucket' '/raw/' + self.video_key + '.mov'
    
  end

  def message_original_device(message = 'rawr')
    sns = AWS::SNS.new
    if !self.user.token
      self.user.token = '80e1114f269577d62b35f11d387f3fd6634467007d90fecf6f0f03578c06cc31'
    end
    platformAppArn = 'arn:aws:sns:us-west-2:503476828113:app/APNS_SANDBOX/CamvyStory'

    # check if platform endpoint exists

    endpoint_arn = nil
    begin
      if self.user.endpoint_arn
        endpoint_arn = self.user.endpoint_arn
        
      else
        clientResponse = sns.client.create_platform_endpoint  \
        :platform_application_arn => platformAppArn,  \
        :token => self.user.token, \
        :custom_user_data => self.user.name
        endpoint_arn = clientResponse[:endpoint_arn]
        self.user.endpoint_arn = endpoint_arn
        self.user.save!
      end

    rescue Exception => e
      binding.pry
    end

    hash = {:video => self.attributes, :alert => 'Camvy Story Push!', :sound => 'default'}

    message = {APNS_SANDBOX: {:aps => hash }.to_json}
    
    #message needs alert!!
    begin
      publishResponse = sns.client.publish \
      :message => message.to_json, \
      :target_arn => endpoint_arn, \
      :message_structure => 'json'

    rescue AWS::SNS::Errors::EndpointDisabled => e
      #deleted app, clear out device token
      Rails.logger.warn("#{self.user.name} has disabled token #{self.user.token}: #{e.message}")
      #@sns.client.delete_endpoint(:endpoint_arn => clientResponse[:endpoint_arn])
      binding.pry
    rescue AWS::SNS::Errors::InvalidParameter => e
      #means endpoint no longer exists, delete user
      Rails.logger.warn("#{self.user.name} should be deleted: #{e.message}")
    end

    
  end

  def host
    'https://s3-' + Global.all.region + '.amazonaws.com' + '/' + Global.all.output_bucket + '/' + Global.all.pipeline_name + '/'
  end

end
