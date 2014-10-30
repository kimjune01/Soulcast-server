Factory.define :video do |v|
	v.sequence(:video_key) { |n| "video_key_#{n}" }
	v.epoch = 65432345
end