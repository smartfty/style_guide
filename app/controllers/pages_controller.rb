class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy, :download_pdf, :regenerate_pdf, :change_template]

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @working_articles = @page.working_articles
    @ad_boxes         = @page.ad_boxes
    @page_templates   = Section.where(page_number: @page.page_number)
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        request.referrer
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # download output.pdf
  def download_pdf
    send_file @page.pdf_path, :type=>'application/pdf', :x_sendfile=>true, :disposition => "attachment"
  end

  def regenerate_pdf
    @page.regenerate_pdf
    request.referrer
    redirect_to @page, notice: '저장된 다락 스타일을 사용한 페이지가 성공적으로 생성 되었습니다.'
  end

  def change_template
    new_template_id = params[:template_id]
    @page.change_template(new_template_id)
    respond_to do |format|
        format.js   {render :js => "window.location = '#{page_path(@page)}'"}
    end
    # redirect_to @page, notice: '페이지가 성공적으로 바뀌었습니다.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:page_number, :section_name, :column, :row, :ad_type, :story_count, :color_page, :profile, :issue_id, :template_id)
    end
end
