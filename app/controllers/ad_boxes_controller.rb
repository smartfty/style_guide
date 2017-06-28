class AdBoxesController < ApplicationController
  before_action :set_ad_box, only: [:show, :edit, :update, :destroy]

  # GET /ad_boxes
  # GET /ad_boxes.json
  def index
    @ad_boxes = AdBox.all
  end

  # GET /ad_boxes/1
  # GET /ad_boxes/1.json
  def show
  end

  # GET /ad_boxes/new
  def new
    @ad_box = AdBox.new
  end

  # GET /ad_boxes/1/edit
  def edit
  end

  # POST /ad_boxes
  # POST /ad_boxes.json
  def create
    @ad_box = AdBox.new(ad_box_params)

    respond_to do |format|
      if @ad_box.save
        format.html { redirect_to @ad_box, notice: 'Ad box was successfully created.' }
        format.json { render :show, status: :created, location: @ad_box }
      else
        format.html { render :new }
        format.json { render json: @ad_box.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ad_boxes/1
  # PATCH/PUT /ad_boxes/1.json
  def update
    respond_to do |format|
      if @ad_box.update(ad_box_params)
        format.html { redirect_to @ad_box, notice: 'Ad box was successfully updated.' }
        format.json { render :show, status: :ok, location: @ad_box }
      else
        format.html { render :edit }
        format.json { render json: @ad_box.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ad_boxes/1
  # DELETE /ad_boxes/1.json
  def destroy
    @ad_box.destroy
    respond_to do |format|
      format.html { redirect_to ad_boxes_url, notice: 'Ad box was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ad_box
      @ad_box = AdBox.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ad_box_params
      params.require(:ad_box).permit(:column, :row, :ad_type, :advertiser, :page_id)
    end
end
