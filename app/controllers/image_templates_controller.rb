class ImageTemplatesController < ApplicationController
  before_action :set_image_template, only: [:show, :edit, :update, :destroy]

  # GET /image_templates
  # GET /image_templates.json
  def index
    @image_templates = ImageTemplate.all
  end

  # GET /image_templates/1
  # GET /image_templates/1.json
  def show
  end

  # GET /image_templates/new
  def new
    @image_template = ImageTemplate.new
  end

  # GET /image_templates/1/edit
  def edit
  end

  # POST /image_templates
  # POST /image_templates.json
  def create
    @image_template = ImageTemplate.new(image_template_params)

    respond_to do |format|
      if @image_template.save
        format.html { redirect_to @image_template, notice: 'Image template was successfully created.' }
        format.json { render :show, status: :created, location: @image_template }
      else
        format.html { render :new }
        format.json { render json: @image_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /image_templates/1
  # PATCH/PUT /image_templates/1.json
  def update
    respond_to do |format|
      if @image_template.update(image_template_params)
        format.html { redirect_to @image_template, notice: 'Image template was successfully updated.' }
        format.json { render :show, status: :ok, location: @image_template }
      else
        format.html { render :edit }
        format.json { render json: @image_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /image_templates/1
  # DELETE /image_templates/1.json
  def destroy
    @image_template.destroy
    respond_to do |format|
      format.html { redirect_to image_templates_url, notice: 'Image template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def duplicate
    #code
  end

  def six
    @image_templates = ImageTemplate.six_column.order(:column).page(params[:page]).per(20)
    # @sections = Section.six_column
  end

  def seven
    @image_templates = ImageTemplate.seven_column.order(:column).page(params[:page]).per(20)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image_template
      @image_template = ImageTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_template_params
      params.require(:image_template).permit(:column, :row, :height_in_lines, :image_path, :caption_title, :caption, :position, :page_columns, :article_id, :publication_id)
    end
end
