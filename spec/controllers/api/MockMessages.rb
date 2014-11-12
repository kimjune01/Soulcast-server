
class MockMessages

  def failMessage
    message = {"state"=>"ERROR",\
     "version"=>"2012-09-25",\
     "jobId"=>"1415757281064-ze3kma",\
     "pipelineId"=>"1403931885121-2js8o0",\
     "input"=>{"key"=>"raw/june0008.mov"},\
     "outputKeyPrefix"=>"kinder/june0008/",\
     "outputs"=>\
      [{"id"=>"1",\
        "presetId"=>"1351620000001-200050",\
        "key"=>"hls0400k/june0008",\
        "segmentDuration"=>5.0,\
        "status"=>"Error",\
        "statusDetail"=>\
         "3002 97b2b99e-b24f-4e5f-ada2-86f1ca4320d0: The specified object could not be saved in the specified bucket because an object by that name already exists: bucket=supman, key=kinder/june0008/hls0400k/june000800000.ts.",\
        "errorCode"=>3002},\
       {"id"=>"2",\
        "presetId"=>"1351620000001-200030",\
        "key"=>"hls1000k/june0008",\
        "segmentDuration"=>5.0,\
        "status"=>"Error",\
        "statusDetail"=>\
         "3002 2b660442-3aa7-402a-81d3-321847b37ee1: The specified object could not be saved in the specified bucket because an object by that name already exists: bucket=supman, key=kinder/june0008/hls1000k/june000800000.ts.",\
        "errorCode"=>3002},\
       {"id"=>"3",\
        "presetId"=>"1408664265595-9xo24q",\
        "key"=>"webm_june0008",\
        "status"=>"Error",\
        "statusDetail"=>\
         "3002 6fe5e175-6827-4a7c-a84f-9533b599e03c: The specified object could not be saved in the specified bucket because an object by that name already exists: bucket=supman, key=kinder/june0008/webm_june0008.",\
        "errorCode"=>3002}],\
     "playlists"=>\
      [{"name"=>"hls_june0008",\
        "format"=>"HLSv3",\
        "outputKeys"=>["hls0400k/june0008", "hls1000k/june0008"],\
        "status"=>"Error",\
        "statusDetail"=>\
         "1001 5fcd2e3a-9959-4a85-89e2-1f401b1c74bf: Amazon Elastic Transcoder could not generate the playlist because it encountered an error with one or more of the playlists dependencies."}]}
    return message
  end

  def successMessage
    message = {"state"=>"COMPLETED",\
     "version"=>"2012-09-25",\
     "jobId"=>"1415757680260-88yivk",\
     "pipelineId"=>"1403931885121-2js8o0",\
     "input"=>{"key"=>"raw/june0008.mov"},\
     "outputKeyPrefix"=>"kinder/june0008/",\
     "outputs"=>\
      [{"id"=>"1",\
        "presetId"=>"1351620000001-200050",\
        "key"=>"hls0400k/june0008",\
        "segmentDuration"=>5.0,\
        "status"=>"Complete",\
        "duration"=>4,\
        "width"=>216,\
        "height"=>288},\
       {"id"=>"2",\
        "presetId"=>"1351620000001-200030",\
        "key"=>"hls1000k/june0008",\
        "segmentDuration"=>5.0,\
        "status"=>"Complete",\
        "duration"=>4,\
        "width"=>324,\
        "height"=>432},\
       {"id"=>"3",\
        "presetId"=>"1408664265595-9xo24q",\
        "key"=>"webm_june0008",\
        "status"=>"Complete",\
        "duration"=>5,\
        "width"=>480,\
        "height"=>640}],\
     "playlists"=>\
      [{"name"=>"hls_june0008", "format"=>"HLSv3", "outputKeys"=>["hls0400k/june0008", "hls1000k/june0008"], "status"=>"Complete"}]}
      return message
  end




end