class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :clone_pages, :edit, :update, :current_plan, :images, :upload_images, :ad_images, :upload_ad_images, :destroy, :slide_show, :assign_reporter, :send_to_cms, :send_xml_to_ebiz, :merge_container_xml]

  # GET /issues
  # GET /issues.json
  def index
    @issues = Issue.all
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    @pages = @issue.pages.order(:id, 'desc')
    @pages = @issue.pages
  end

  # GET /issues/new
  def new
    @issue            = Issue.new
    @publication      = Publication.first
    @previous_date    = Issue.last.date.to_s        if Issue.last
    @previous_number  = Issue.last.number.to_i      if Issue.last
    @new_issue_number = Issue.last.number.to_i + 1  if Issue.last
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
        @issue.make_pages
        format.html { redirect_to @issue}
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
        format.html { redirect_to @issue}
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

  def demo
    #code
  end

  #
  # SECTIONS = [
  #   '1면',
  #   '정치',
  #   '행정',
  #   '국제통일',
  #   '금융',
  #   '산업',
  #   '정책',
  #   '기획',
  #   '오피니언',
  # ]
  #
#   1
# 2_4
# 5_6
# 8
# 10_13
# 14-17
# 18_19
# 20_21
# 22-23
  def first_group
    set_issue
    @pages = @issue.pages.order(:id)
    @page_range = 0..0
    session[:current_group] = 'first_group'
  end

  def second_group
    set_issue
    session[:current_group] = 'second_group'
    @page_range = 1..4
  end

  def third_group
    set_issue
    @page_range = 4..5
    session[:current_group] = 'third_group'
  end

  def fourth_group
    set_issue
    @page_range = 7..7
    session[:current_group] = 'fourth_group'
  end

  def fifth_group
    set_issue
    @page_range = 9..12
    session[:current_group] = 'fifth_group'
  end

  def sixth_group
    set_issue
    @page_range = 13..16
    session[:current_group] = 'sixth_group'
  end

  def seventh_group
    set_issue
    session[:current_group] = 'seventh_group'
    @page_range = 17..18
  end

  def eighth_group
    set_issue
    session[:current_group] = 'eighth_group'
    @page_range = 19..20
  end

  # 오피니언
  def nineth_group
    set_issue
    session[:current_group] = 'nineth_group'
    @page_range = 21..22
  end

  def ad_group
    set_issue
    session[:current_group] = 'ad_group'
    @pages = []

    [6,8,10,23].each do |i|
      @pages << @issue.pages[i]
    end
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
    @issue.request_cms_new_issue
    redirect_to assign_reporter_issue_path(@issue)
  end

  def save_story_xml
    set_issue
    if File.exist?(@issue.xml_zip_path)
      system("rm #{@issue.xml_zip_path}")
      @issue.save_story_xml
      redirect_to issue_path(@issue), notice: 'xml 파일이 재생성 되었습니다.'
    else
      @issue.save_story_xml
      redirect_to issue_path(@issue), notice: 'xml 파일이 생성 되었습니다.'
    end
  end

  def save_preview_xml
    set_issue
    if File.exist?(@issue.preview_xml_zip_path)
      system("rm #{@issue.preview_xml_zip_path}")
      @issue.save_preview_xml
      redirect_to issue_path(@issue), notice: '지면보기용 xml 파일이 재생성 되었습니다.'
    else
      @issue.save_preview_xml
      redirect_to issue_path(@issue), notice: '지면보기용 xml 파일이 생성 되었습니다.'
    end
  end

  def download_story_xml
    set_issue
    # send_file @issue.xml_zip_path, type: 'application/zip'
    respond_to do |format|
      format.zip { send_data File.open(@issue.xml_zip_path, 'r'){|f| f.read} }
      # zip: {send_data File.open(@issue.xml_zip_path, 'r'){|f| f.read} }
    end
    # send_file @issue.xml_zip_path, :type=>'application/zip', :x_sendfile=>true, :disposition => "attachment", :filename =>filename
    # send_file @issue.xml_zip_path, :type=>'application/zip', :disposition => "attachment", :filename =>filename

    # redirect_to issue_path(@issue), notice: 'xml 다운로드 되었습니다.'
  end

  def send_xml_to_ebiz
    result = @issue.copy_to_xml_ftp
    if result
      redirect_to @issue, notice: '뉴스와 지면보기용 xml 파일이 전송 되었습니다.'
    else
      redirect_to @issue, notice: "#{result}"
    end
  end

  def save_mobile_preview_xml
    set_issue
    if File.exist?(@issue.mobile_preview_xml_zip_path)
      system("rm #{@issue.mobile_preview_xml_zip_path}")
      @issue.save_mobile_preview_xml
      redirect_to issue_path(@issue), notice: '모바일용 지면보기 xml 파일이 재생성 되었습니다.'
    else
      @issue.save_mobile_preview_xml
      redirect_to issue_path(@issue), notice: '모바일용 지면보기 xml 파일이 생성 되었습니다.'
    end
  end

  def download_preview_xml
    set_issue
    respond_to do |format|
      format.zip { send_data File.open(@issue.preview_xml_zip_path, 'r'){|f| f.read} }
      # zip: {send_data File.open(@issue.xml_zip_path, 'r'){|f| f.read} }
    end
  end

  def merge_container_xml
    @issue.merge_container_xml
    redirect_to issue_path(@issue), notice: '모바일용 지면보기 xml 파일이 합성 되었습니다.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      if params[:id]
        # @issue = Issue.find(params[:id])
        @issue = Issue.friendly.find(params[:id])

      else
        @issue = Issue.last
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      # params.require(:issue).permit(:date, :number, :plan, :publication_id, images_attributes: [:id, :issue_id, :image])
      params.require(:issue).permit(:date, :number, :plan, :publication_id, images_attributes: [:id, :issue_id, :image])
    end
end
