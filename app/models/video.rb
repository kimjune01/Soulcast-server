class Video < ActiveRecord::Base
  belongs_to :message
  belongs_to :user

  # validates :video_key, presence: true, uniqueness: true
  validates :epoch,    presence: true
  # validates :user_id,  presence: true

  # before_save :transcode
  after_save :savedAfterTranscodeRequest

  def transcode
  	transcoder = Transcoder.new
  	self.jobID = transcoder.transcode(self)
  end

  def mark_as_transcoded!
    self.transcoded = true
    #give it its webm and hls values
    region = 'us-west-2'
    amazonHost = 'https://s3-' + region + '.amazonaws.com'
    bucketName = 'supman'
    pipelineName = 'kinder'
    hlsPrefix = 'hls_'
    hlsSuffix = '.m3u8'
    webmPrefix = 'webm_'

    # /webm_june0008out
    self.webm = amazonHost + '/' + bucketName + '/' + pipelineName + '/' + webmPrefix + self.video_key
    self.hls = amazonHost + '/' + bucketName + '/' + pipelineName + '/' + hlsPrefix + self.video_key + hlsSuffix;
    #save it

    self.save!
  end

  def savedAfterTranscodeRequest

  end
end
