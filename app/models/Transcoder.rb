class Transcoder
	def initialize

	end

	def transcode(video)
		##
		video.video_key = 'june0008'
		##

		region = 'us-west-2'
		transcoder_client = AWS::ElasticTranscoder::Client.new(region: region)

		pipeline_id = '1403931885121-2js8o0'
		input_key = 'raw/' + video.video_key + '.mov'
		hls_0400k_preset_id     = '1351620000001-200050';
		hls_1000k_preset_id     = '1351620000001-200030';
		webm_preset_id   			  = '1408664265595-9xo24q';

		segment_duration = '5'
		input = { key: input_key }
		output_key_prefix = 'kinder/'
		output_key = video.video_key

		hls_400k = { key: 'hls0400k/' + output_key,  preset_id: hls_0400k_preset_id, segment_duration: segment_duration }
		hls_1000k = { key: 'hls1000k/' + output_key, preset_id: hls_1000k_preset_id, segment_duration: segment_duration }
		webm = { key: 'webm_' + output_key, preset_id: webm_preset_id }

		hls_outputs = [hls_400k, hls_1000k]
		webm_outputs = [webm]

		hls_playlist = {
		  name: 'hls_' + output_key,
		  format: 'HLSv3',
		  output_keys: hls_outputs.map { |output| output[:key] }
		}

		trasncodeRequest = transcoder_client.create_job(
		  pipeline_id: pipeline_id,
		  input: input,
		  output_key_prefix: output_key_prefix + output_key + '/',
		  outputs: hls_outputs + webm_outputs,
		  playlists: [ hls_playlist ])
		
		jobID = trasncodeRequest[:job][:id]
		
		return jobID

	end


end
