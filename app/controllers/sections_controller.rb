class SectionsController < ApplicationController
  before_action :set_section, only: [:show, :edit, :update, :destroy, :download_pdf, :duplicate, :regenerate_pdf]

  # GET /sections
  # GET /sections.json
  def index
    @q = Section.ransack(params[:q])
    @sections = @q.result.order(:ad_type, :page_number, :column).page(params[:page]).per(20)
    respond_to do |format|
      format.html
      format.json { render :index}

      format.csv { send_data @sections.to_csv }
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end
  end

  # GET /sections/1
  # GET /sections/1.json
  def show
  end

  # GET /sections/new
  def new
    @section = Section.new
  end

  # GET /sections/1/edit
  def edit
  end

  # POST /sections
  # POST /sections.json
  def create
    @section = Section.new(section_params)
    respond_to do |format|
      if @section.save
        format.html { redirect_to @section, notice: 'Section was successfully created.' }
        format.json { render :show, status: :created, location: @section }
      else
        format.html { render :new }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sections/1
  # PATCH/PUT /sections/1.json
  def update
    respond_to do |format|
      if @section.update(section_params)
        @section.update_section_layout
        format.html { redirect_to @section, notice: 'Section was successfully updated.' }
        format.json { render :show, status: :ok, location: @section }
      else
        format.html { render :edit }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to sections_url, notice: 'Section was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def duplicate
    # @new_section = Section.new(@section.attributes)
    @new_section = Section.create(@section.attributes.merge({id: nil }))
    respond_to do |format|
      if @new_section
        format.html { redirect_to sections_path, notice: 'Section was successfully duplicated.'}
      else
        format.html { redirect_to sections_url, notice: 'Section could not be duplicated.' }
      end
    end
  end

  # download story.pdf
  def download_pdf
    send_file @section.pdf_path, :type=>'application/pdf', :x_sendfile=>true, :disposition => "attachment"
  end

  def regenerate_pdf
    @section.regenerate_pdf
    redirect_to @section, notice: '저장된 다락 스타일을 사용한 페이지가 성공적으로 생성 되었습니다.'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:section).permit(:profile, :column, :row, :ad_type, :is_front_page, :story_count, :page_number, :section_name, :layout, :color_page)
    end
end
