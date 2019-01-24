class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy, :download_pdf, :save_proof_reading_pdf, :send_pdf_to_printer, :dropbox, :regenerate_pdf, :change_template, :save_current_as_default, :assign_stories]

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all.includes(:issue)
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @working_articles = @page.working_articles
    @ad_boxes         = @page.ad_boxes
    @page_templates   = Section.where(ad_type:@page.ad_type, page_number: @page.page_number)
    if @page.page_number != 1
      if @page.page_number == 22 || @page.page_number == 23
        # do not add any
      elsif @page.page_number.even? && 
        @page_templates   += Section.where(ad_type:@page.ad_type, page_number: 100)
      else @page.page_number.odd?
        @page_templates   += Section.where(ad_type:@page.ad_type, page_number: 101)
      end
    end
    # respond_to do |format|
    #   format.html
    #   # format.pdf {send_file @page.pdf_path, :type=>'application/pdf', :x_sendfile=>true, :disposition => "attachment"}
    #   format.jpg {send_date @page.jpg_path, :type=>'application/jpg'}
    # end
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
        format.html { redirect_to @page, notice: '페이지가 성공적으로 생성 되었습니다.' }
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
        # format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.html {render :js => "window.location = '#{page_path(@page)}'"}

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
      format.html { redirect_to pages_url, notice: '페이지가 삭제 되었습니다.' }
      format.json { head :no_content }
    end
  end

  # download story.pdf
  def download_pdf
    send_file @page.pdf_path, :type=>'application/pdf', :x_sendfile=>true, :disposition => "attachment"
  end

  def save_proof_reading_pdf
    result = @page.copy_to_proof_reading_ftp
    if result
      redirect_to @page, notice: '교열용 PDF가 저장 되었습니다,.'
    else
      redirect_to @page, notice: "#{result}"
    end
  end

  def send_pdf_to_printer
    puts __method__
    result = @page.copy_to_printer_ftp
    if result
      redirect_to @page, notice: '#{page_number}페이지의 인쇄용 PDF가 전송 되었습니다...'
    else
      redirect_to @page, notice: "#{result}"
    end
  end

  def dropbox
    result = @page.copy_to_drop_box
    if result
      redirect_to @page, notice: '페이지가 성공적으로 드롭박스에 저장 되었습니다,.'
    else
      redirect_to @page, notice: "#{result}"

    end
  end

  def regenerate_pdf
    @page.regenerate_pdf
    request.referrer
    redirect_to @page, notice: '저장된 단락 스타일을 사용한 페이지가 성공적으로 생성 되었습니다.'
  end

  def change_template
    new_template_id = params[:template_id]
    @page.change_template(new_template_id)
    respond_to do |format|
        format.js   {render :js => "window.location = '#{page_path(@page)}'"}
    end
  end

  def save_current_as_default
    @page.save_as_default
    redirect_to @page, notice: '현 페이지를 시작 페이지로 설정 하였습니다.'
  end


  def assign_stories
    @page = Page.includes(:working_articles).find(params[:id])
    @stories = Story.where(date: @page.date, group: @page.section_name)
    render :assign_stories
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      # @page = Page.find(params[:id])
      @page = Page.includes(:issue, :working_articles).find(params[:id])

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:page_number, :section_name, :column, :row, :ad_type, :story_count, :draw_divider, :color_page, :profile, :issue_id, :template_id)
    end
end
