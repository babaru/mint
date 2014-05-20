class TimeRecordsController < ApplicationController
  # GET /time_records
  # GET /time_records.json
  def index
    @time_records_grid = initialize_grid(TimeRecord)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: TimeRecord.where(user_id: params[:user_id]).to_json }
    end
  end

  # GET /time_records/1
  # GET /time_records/1.json
  def show
    @time_record = TimeRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @time_record }
    end
  end

  # GET /time_records/new
  # GET /time_records/new.json
  def new
    @time_record = TimeRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @time_record }
    end
  end

  # GET /time_records/1/edit
  def edit
    @time_record = TimeRecord.find(params[:id])
  end

  # POST /time_records
  # POST /time_records.json
  def create
    @time_record = TimeRecord.new(params[:time_record])
    @time_record.value = (@time_record.ended_at - @time_record.started_at) / 1.hour
    @time_record.recorded_on = @time_record.started_at.to_date

    respond_to do |format|
      if @time_record.save
        format.html { redirect_to time_records_path, notice: 'Time record was successfully created.' }
        format.json { render json: @time_record.to_json, status: :created, location: @time_record }
      else
        format.html { render action: "new" }
        format.json { render json: @time_record.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_records/1
  # PATCH/PUT /time_records/1.json
  def update
    @time_record = TimeRecord.find(params[:id])

    respond_to do |format|
      if @time_record.update_attributes(params[:time_record])
        format.html { redirect_to time_records_path, notice: 'Time record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @time_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_records/1
  # DELETE /time_records/1.json
  def destroy
    @time_record = TimeRecord.find(params[:id])
    @time_record.destroy

    respond_to do |format|
      format.html { redirect_to time_records_url }
      format.json { head :no_content }
    end
  end

  def upload
    @upload_file = UserTimeRecordFile.new

    if request.post?
      @upload_file = UserTimeRecordFile.new(params[:user_time_record_file])
      if @upload_file.save
        @user = User.find @upload_file.user_id
        time_record_data = @upload_file.parse

        TimeRecord.transaction do
          time_record_data.each do |item|
            project = Project.find_by_name(item[:project_name]) || Project.create!(name: item[:project_name])
            project.users << @user unless project.users.include?(@user)
            TimeRecord.find_by_user_id_and_project_id_and_recorded_on(@user.id, project.id, item[:recorded_on]) || TimeRecord.create!(
              {
                user_id: @user.id,
                project_id: project.id,
                value: item[:time_record],
                recorded_on: item[:recorded_on],
                task_type_id: TaskType.first.id
              })
          end
        end

        redirect_to upload_time_records_path, notice: "#{@user.name} #{TimeRecord.model_name.human} 上传完毕"
      else
        render :upload
      end
    end
  end
end
