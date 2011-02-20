class ImagesController < ApplicationController
  respond_to :html
  
  def index
    @images = Image.all
    respond_with(@images)
  end
  
  def show
    @image = Image.find(params[:id])
    respond_with(@image)
  end
  
  def new
    @image = Image.new
    respond_with(@image)
  end
  
  def create
    @image = Image.create(params[:image])
    respond_with(@image, :notice => 'Successfully created image')
  end
  
  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    respond_with(@image, :notice => 'Successfully deleted image', :location => images_url)
  end
end
