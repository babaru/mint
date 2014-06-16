class OvertimeRecordsController < ApplicationController
  before_filter :authenticate_user!
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
      format.json { render json: OvertimeRecord.where(@conditions).collect{|t| t.to_user_feed}.to_json }
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

  def upload
    @upload_file = UserOvertimeRecordFile.new

    if request.post?
      @upload_file = UserOvertimeRecordFile.new(params[:user_overtime_record_file])
      if @upload_file.save
        time_record_data = @upload_file.parse
        logger.debug time_record_data

        TimeRecord.transaction do
          time_record_data.each do |user_name, items|
            user = User.where("name like '%#{user_name}%'").first
            if user
              items.each do |time, value|
                OvertimeRecord.find_by_user_id_and_recorded_on(user.id, time) || OvertimeRecord.create!(
                  {
                    user_id: user.id,
                    recorded_on: time,
                    started_at: Time.new(time.year, time.month, time.day, 18),
                    ended_at: Time.new(time.year, time.month, time.day, 18 + value),
                    value: value,
                    remark: 'IFF'
                  })
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
