class OvertimeRecordsController < ApplicationController
  # GET /overtime_records
  # GET /overtime_records.json
  def index
    @overtime_records_grid = initialize_grid(OvertimeRecord)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @overtime_records_grid }
    end
  end

  def user_feed
    @started_at = Time.at(params[:start].to_i)
    @ended_at = Time.at(params[:end].to_i)

    respond_to do |format|
      format.json { render json: OvertimeRecord.where(recorded_on: (@started_at..@ended_at)).collect{|t| t.to_user_feed}.to_json }
    end
  end

  # GET /overtime_records/1
  # GET /overtime_records/1.json
  def show
    @overtime_record = OvertimeRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @overtime_record }
    end
  end

  # GET /overtime_records/new
  # GET /overtime_records/new.json
  def new
    @overtime_record = OvertimeRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @overtime_record }
    end
  end

  # GET /overtime_records/1/edit
  def edit
    @overtime_record = OvertimeRecord.find(params[:id])
  end

  # POST /overtime_records
  # POST /overtime_records.json
  def create
    @overtime_record = OvertimeRecord.new(params[:overtime_record])

    respond_to do |format|
      if @overtime_record.save
        format.html { redirect_to overtime_records_path, notice: 'Overtime record was successfully created.' }
        format.json { render json: @overtime_record, status: :created, location: @overtime_record }
      else
        format.html { render action: "new" }
        format.json { render json: @overtime_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /overtime_records/1
  # PATCH/PUT /overtime_records/1.json
  def update
    @overtime_record = OvertimeRecord.find(params[:id])

    respond_to do |format|
      if @overtime_record.update_attributes(params[:overtime_record])
        format.html { redirect_to overtime_records_path, notice: 'Overtime record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @overtime_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /overtime_records/1
  # DELETE /overtime_records/1.json
  def destroy
    @overtime_record = OvertimeRecord.find(params[:id])
    @overtime_record.destroy

    respond_to do |format|
      format.html { redirect_to overtime_records_url }
      format.json { head :no_content }
    end
  end
end
