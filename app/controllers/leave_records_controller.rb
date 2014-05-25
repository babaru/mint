class LeaveRecordsController < ApplicationController
  # GET /leave_records
  # GET /leave_records.json
  def index
    @leave_records_grid = initialize_grid(LeaveRecord)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: LeaveRecord.all.to_json }
    end
  end

  # GET /user_time_records_feed.json
  def user_feed
    @started_at = Time.at(params[:start].to_i)
    @ended_at = Time.at(params[:end].to_i)

    respond_to do |format|
      format.json { render json: TimeRecord.where(recorded_on: (@started_at..@ended_at)).collect{|t| t.to_user_feed}.to_json }
    end
  end

  # GET /leave_records/1
  # GET /leave_records/1.json
  def show
    @leave_record = LeaveRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @leave_record }
    end
  end

  # GET /leave_records/new
  # GET /leave_records/new.json
  def new
    @leave_record = LeaveRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @leave_record }
    end
  end

  # GET /leave_records/1/edit
  def edit
    @leave_record = LeaveRecord.find(params[:id])
  end

  # POST /leave_records
  # POST /leave_records.json
  def create
    @leave_record = LeaveRecord.new(params[:leave_record])
    @leave_record.value = (@leave_record.ended_at - @leave_record.started_at) / 1.hour
    @leave_record.recorded_on = @leave_record.started_at.to_date

    respond_to do |format|
      if @leave_record.save
        format.html { redirect_to leave_records_path, notice: 'Leave record was successfully created.' }
        format.json { render json: @leave_record, status: :created, location: @leave_record }
      else
        format.html { render action: "new" }
        format.json { render json: @leave_record.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leave_records/1
  # PATCH/PUT /leave_records/1.json
  def update
    @leave_record = LeaveRecord.find(params[:id])

    respond_to do |format|
      if @leave_record.update_attributes(params[:leave_record])
        format.html { redirect_to leave_records_path, notice: 'Leave record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @leave_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leave_records/1
  # DELETE /leave_records/1.json
  def destroy
    @leave_record = LeaveRecord.find(params[:id])
    @leave_record.destroy

    respond_to do |format|
      format.html { redirect_to leave_records_url }
      format.json { head :no_content }
    end
  end
end
