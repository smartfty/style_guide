class ExertWritersController < ApplicationController
  before_action :set_exert_writer, only: [:show, :edit, :update, :destroy]

  # GET /exert_writers
  # GET /exert_writers.json
  def index
    @exert_writers = ExertWriter.all
  end

  # GET /exert_writers/1
  # GET /exert_writers/1.json
  def show
  end

  # GET /exert_writers/new
  def new
    @exert_writer = ExertWriter.new
  end

  # GET /exert_writers/1/edit
  def edit
  end

  # POST /exert_writers
  # POST /exert_writers.json
  def create
    @exert_writer = ExertWriter.new(exert_writer_params)

    respond_to do |format|
      if @exert_writer.save
        format.html { redirect_to @exert_writer, notice: 'Exert writer was successfully created.' }
        format.json { render :show, status: :created, location: @exert_writer }
      else
        format.html { render :new }
        format.json { render json: @exert_writer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exert_writers/1
  # PATCH/PUT /exert_writers/1.json
  def update
    respond_to do |format|
      if @exert_writer.update(exert_writer_params)
        format.html { redirect_to @exert_writer, notice: 'Exert writer was successfully updated.' }
        format.json { render :show, status: :ok, location: @exert_writer }
      else
        format.html { render :edit }
        format.json { render json: @exert_writer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exert_writers/1
  # DELETE /exert_writers/1.json
  def destroy
    @exert_writer.destroy
    respond_to do |format|
      format.html { redirect_to exert_writers_url, notice: 'Exert writer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exert_writer
      @exert_writer = ExertWriter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exert_writer_params
      params.require(:exert_writer).permit(:name, :work, :position, :email, :category_code, :expert_image, :expert_jpg_image)
    end
end
