class PagePlansController < ApplicationController
  before_action :set_page_plan, only: [:show, :edit, :update, :destroy]

  # GET /page_plans
  # GET /page_plans.json
  def index
    @page_plans = PagePlan.all
  end

  # GET /page_plans/1
  # GET /page_plans/1.json
  def show
  end

  # GET /page_plans/new
  def new
    @page_plan = PagePlan.new
  end

  # GET /page_plans/1/edit
  def edit
  end

  # POST /page_plans
  # POST /page_plans.json
  def create
    @page_plan = PagePlan.new(page_plan_params)

    respond_to do |format|
      if @page_plan.save
        format.html { redirect_to @page_plan, notice: 'Page plan was successfully created.' }
        format.json { render :show, status: :created, location: @page_plan }
      else
        format.html { render :new }
        format.json { render json: @page_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /page_plans/1
  # PATCH/PUT /page_plans/1.json
  def update
    puts "page_plan_params:#{page_plan_params}"
    respond_to do |format|
      if @page_plan.update(page_plan_params)
        format.html { redirect_to @page_plan, notice: 'Page plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @page_plan }
      else
        format.html { render :edit }
        format.json { render json: @page_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /page_plans/1
  # DELETE /page_plans/1.json
  def destroy
    @page_plan.destroy
    respond_to do |format|
      format.html { redirect_to page_plans_url, notice: 'Page plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_plan
      @page_plan = PagePlan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_plan_params
      params.require(:page_plan).permit(:page_number, :section_name, :ad_type, :advertiser, :color_page, :issue_id)
    end
end
