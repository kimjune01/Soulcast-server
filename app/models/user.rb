class User < ActiveRecord::Base
  has_many :videos
  #has_many :sent_messages, foreign_key: :from_id, class_name: 'Message'
  #has_many :received_messages, foreign_key: :to_id, class_name: 'Message'
  validates :phone, presence: true
  validates :token, presence: true, uniqueness: true
  validates :endpoint_arn, presence: true, uniqueness: true

  def before_save
    #save only the last 10 digits of phone number
    self.phone = self.phone.split(//).last(10).join
  end

  def create_endpoint_arn
    if !self.token || self.endpoint_arn
      return
    end

    begin # can only perform once per token
      clientResponse = AWS::SNS.new.client.create_platform_endpoint  \
      :platform_application_arn => Global.all.platformAppArn,  \
      :token => self.token, \
      :custom_user_data => self.phone
      self.endpoint_arn = clientResponse[:endpoint_arn]
    rescue Exception => e
      binding.pry
      #endpoint already exists! What to do? TODO
    end

  end

  def is_on_camvy
    

    begin
      message = {APNS_SANDBOX: {:aps => {'content-available' => 1, 'is_on_camvy' => '???'} }.to_json}
      publishResponse = AWS::SNS.new.client.publish \
      :message => message.to_json, \
      :target_arn => self.endpoint_arn, \
      :message_structure => 'json'
      puts publishResponse
      true
    rescue AWS::SNS::Errors::EndpointDisabled => e
      #deleted app, clear out device token
      false
    rescue AWS::SNS::Errors::InvalidParameter => e
      #means endpoint no longer exists, delete user
      false
    end

    true

  end



end



