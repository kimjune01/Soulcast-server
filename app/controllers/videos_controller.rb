class VideosController < ApplicationController
 
  def show
    @video = Video.find_by(vanity: params[:vanity])
    
  end

  def index
    @allVideos = Video.all
    puts @allVideos.size
    render json: @allVideos
  end


end
