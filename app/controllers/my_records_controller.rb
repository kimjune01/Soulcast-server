class MyRecordsController < ApplicationController
  before_action :set_my_record, only: [:show, :edit, :update, :destroy]

  # GET /my_records
  # GET /my_records.json
  def index
    @my_records = MyRecord.all
  end

  # GET /my_records/1
  # GET /my_records/1.json
  def show
  end

  # GET /my_records/new
  def new
    @my_record = MyRecord.new
  end

  # GET /my_records/1/edit
  def edit
  end

  # POST /my_records
  # POST /my_records.json
  def create
    @my_record = MyRecord.new(my_record_params)

    respond_to do |format|
      if @my_record.save
        format.html { redirect_to @my_record, notice: 'My record was successfully created.' }
        format.json { render :show, status: :created, location: @my_record }
      else
        format.html { render :new }
        format.json { render json: @my_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /my_records/1
  # PATCH/PUT /my_records/1.json
  def update
    respond_to do |format|
      if @my_record.update(my_record_params)
        format.html { redirect_to @my_record, notice: 'My record was successfully updated.' }
        format.json { render :show, status: :ok, location: @my_record }
      else
        format.html { render :edit }
        format.json { render json: @my_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /my_records/1
  # DELETE /my_records/1.json
  def destroy
    @my_record.destroy
    respond_to do |format|
      format.html { redirect_to my_records_url, notice: 'My record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_my_record
      @my_record = MyRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def my_record_params
      params.require(:my_record).permit(:name)
    end
end
