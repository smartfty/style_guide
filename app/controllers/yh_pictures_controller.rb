class YhPicturesController < ApplicationController
  before_action :set_yh_picture, only: [:show, :edit, :update, :destroy]

  # GET /yh_pictures
  # GET /yh_pictures.json
  def index
    @yh_pictures = YhPicture.all
  end

  # GET /yh_pictures/1
  # GET /yh_pictures/1.json
  def show
  end

  # GET /yh_pictures/new
  def new
    @yh_picture = YhPicture.new
  end

  # GET /yh_pictures/1/edit
  def edit
  end

  # POST /yh_pictures
  # POST /yh_pictures.json
  def create
    @yh_picture = YhPicture.new(yh_picture_params)

    respond_to do |format|
      if @yh_picture.save
        format.html { redirect_to @yh_picture, notice: 'Yh picture was successfully created.' }
        format.json { render :show, status: :created, location: @yh_picture }
      else
        format.html { render :new }
        format.json { render json: @yh_picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /yh_pictures/1
  # PATCH/PUT /yh_pictures/1.json
  def update
    respond_to do |format|
      if @yh_picture.update(yh_picture_params)
        format.html { redirect_to @yh_picture, notice: 'Yh picture was successfully updated.' }
        format.json { render :show, status: :ok, location: @yh_picture }
      else
        format.html { render :edit }
        format.json { render json: @yh_picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /yh_pictures/1
  # DELETE /yh_pictures/1.json
  def destroy
    @yh_picture.destroy
    respond_to do |format|
      format.html { redirect_to yh_pictures_url, notice: 'Yh picture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_yh_picture
      @yh_picture = YhPicture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def yh_picture_params
      params.require(:yh_picture).permit(:action, :service_type, :content_id, :date, :time, :urgency, :category, :class_code, :attriubute_code, :source, :credit, :region, :title, :comment, :bpdy, :file_name, :taken_by)
    end
end
