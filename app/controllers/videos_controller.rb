class VideosController < ApplicationController
 
  def show
    @video = Video.find_by(vanity: params[:vanity])
    render 'show'
  end

  def webm_link
    # https://s3-us-west-2.amazonaws.com/supman/kinder/june1416525474/webm_june1416525474

  end


end
