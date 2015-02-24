class VideosController < ApplicationController
 
  def show
    @video = Video.find_by(vanity: params[:vanity])
    
  end


end
