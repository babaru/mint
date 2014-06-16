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
    @conditions = {}
    @started_at = Time.at(params[:start].to_i)
    @ended_at = Time.at(params[:end].to_i)
    @conditions[:recorded_on] = (@started_at..@ended_at)

    if current_user.is_normal_user?
      @conditions[:user_id] = current_user.id
    else
      @conditions[:user_id] = params[:user_id] if params[:user_id]
    end

    respond_to do |format|
      format.json { render json: LeaveRecord.where(@conditions).collect{|t| t.to_user_feed}.to_json }
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

  def upload
    @upload_file = UserLeaveRecordFile.new

    if request.post?
      @upload_file = UserLeaveRecordFile.new(params[:user_leave_record_file])
      if @upload_file.save
        time_record_data = @upload_file.parse
        logger.debug time_record_data

        TimeRecord.transaction do
          time_record_data.each do |user_name, items|
            user = User.where("name like '%#{user_name}%'").first
            if user
              items.each do |time, value|
                ranges = []
                if value < 1 && value > 0
                  ranges << (Time.new(time.year, time.month, time.day, 14)..Time.new(time.year, time.month, time.day, 18))
                else
                  ranges << (Time.new(time.year, time.month, time.day, 13)..Time.new(time.year, time.month, time.day, 18))
                  ranges << (Time.new(time.year, time.month, time.day, 9)..Time.new(time.year, time.month, time.day, 12))
                end
                ranges.each do |range|
                  LeaveRecord.find_by_user_id_and_started_at_and_ended_at(user.id, range.begin, range.end) || LeaveRecord.create!(
                    {
                      user_id: user.id,
                      recorded_on: time,
                      started_at: range.begin,
                      ended_at: range.end,
                      value: (range.begin - range.end) / 1.hour,
                      remark: 'IFF'
                    })
                end
              end
            end
          end
        end
      else
        render :upload
      end
    end
  end
end
