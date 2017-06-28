class AdImagesController < ApplicationController
  before_action :set_placed_ad, only: [:show, :edit, :update, :destroy]

  # GET /placed_ads
  # GET /placed_ads.json
  def index
    @placed_ads = AdImage.all
  end

  # GET /placed_ads/1
  # GET /placed_ads/1.json
  def show
  end

  # GET /placed_ads/new
  def new
    @placed_ad = AdImage.new
  end

  # GET /placed_ads/1/edit
  def edit
  end

  # POST /placed_ads
  # POST /placed_ads.json
  def create
    @placed_ad = AdImage.new(placed_ad_params)

    respond_to do |format|
      if @placed_ad.save
        format.html { redirect_to @placed_ad, notice: 'Placed ad was successfully created.' }
        format.json { render :show, status: :created, location: @placed_ad }
      else
        format.html { render :new }
        format.json { render json: @placed_ad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /placed_ads/1
  # PATCH/PUT /placed_ads/1.json
  def update
    respond_to do |format|
      if @placed_ad.update(placed_ad_params)
        format.html { redirect_to @placed_ad, notice: 'Placed ad was successfully updated.' }
        format.json { render :show, status: :ok, location: @placed_ad }
      else
        format.html { render :edit }
        format.json { render json: @placed_ad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /placed_ads/1
  # DELETE /placed_ads/1.json
  def destroy
    @placed_ad.destroy
    respond_to do |format|
      format.html { redirect_to placed_ads_url, notice: 'Placed ad was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_placed_ad
      @placed_ad = AdImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def placed_ad_params
      params.require(:placed_ad).permit(:ad_type, :column, :row, :page_id)
    end
end
