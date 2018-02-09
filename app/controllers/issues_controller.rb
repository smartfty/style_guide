class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :clone_pages, :edit, :update, :current_plan, :images, :upload_images, :ad_images, :upload_ad_images, :destroy, :slide_show, :assign_reporter, :send_to_cms]

  # GET /issues
  # GET /issues.json
  def index
    @issues = Issue.all
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  # POST /issues.jsonfredirect_to
  def create
    @issue = Issue.new(issue_params)
    respond_to do |format|
      if @issue.save
        @issue.make_default_issue_plan
        format.html { redirect_to @issue, notice: 'Issue was successfully created.' }
        format.json { render :show, status: :created, location: @issue }
      else
        format.html { render :new }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to issues_url, notice: 'Issue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_plan
    issue = Issue.last
    issue.update_plan
    redirect_to issue_path(issue)
  end

  def current_plan
    @page_plans = @issue.page_plans
  end

  def images
    @issue_images = @issue.images
  end

  def upload_images
    respond_to do |format|
      format.html do
         if @issue.update(issue_params)
           params[:images]['image'].each do |a|
             @image = @issue.images.create!(:image => a, :issue_id => @issue.id)
           end
         end
       end
     end
    redirect_to images_issue_path(@issue.id)
    # images_issue_path(Issue.last.id)
  end

  def ad_images
    @issue_plans_with_ad  = @issue.page_plan_with_ad
    @issue_ad_images      = @issue.ad_images
  end

  def upload_ad_images
    respond_to do |format|
      format.html do
         if @issue.update(issue_params)
           params[:ad_images]['ad_image'].each do |a|
             @ad = @issue.ad_images.create!(:ad_image => a, :issue_id => @issue.id)
           end
         end
       end
     end
    redirect_to ad_images_issue_path(@issue.id)
    # images_issue_path(Issue.last.id)
  end

  def clone_pages
    @clone_pages = Page.clone_pages
  end

  def slide_show

  end

  def assign_reporter
    @reporters        = Reporter.all.order(:division)
    @working_articles = []
    @issue.pages.each do |page|
      @working_articles += page.working_articles
    end#code
  end

  def send_to_cms
    puts __method__
    @issue.request_cms_new_issue
    redirect_to assign_reporter_issue_path(@issue)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      if params[:id]
        @issue = Issue.find(params[:id])
      else
        @issue = Issue.last
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      # params.require(:issue).permit(:date, :number, :plan, :publication_id, images_attributes: [:id, :issue_id, :image])
      params.permit(:date, :number, :plan, :publication_id, images_attributes: [:id, :issue_id, :image])
    end
end
