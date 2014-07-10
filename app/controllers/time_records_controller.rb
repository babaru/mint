class TimeRecordsController < ApplicationController
  before_filter :authenticate_user!

  # GET /time_records
  # GET /time_records.json
  def index
    parse_conditions

    # if @request_kind == :user
    # @time_records_grid = initialize_grid(TimeRecord)

    @project_time_record_grid = initialize_grid(TimeRecord.where(user_id: 4))

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: TimeRecord.where(user_id: params[:user_id]).to_json }
    end
  end

  def parse_conditions
    @conditions, @url_params = {}, {}

    @report_kind = params[:kind]
    @report_kind ||= 'project'
    @report_kind = @report_kind.to_sym
    @url_params[:kind] = @report_kind

    @start_date = Date.parse(params[:start_date]) if params[:start_date]
    @end_date = Date.parse(params[:end_date]) if params[:end_date]

    @start_date ||= Date.new(Date.today.year,1,1)
    @end_date ||= Date.today

    @url_params[:start_date] = @start_date.strftime('%Y-%m-%d')
    @url_params[:end_date] = @end_date.strftime('%Y-%m-%d')

    @conditions[:recorded_on] = (@start_date.beginning_of_day..@end_date.end_of_day)

    @user = User.find params[:user_id] if params[:user_id]
    @project = Project.find params[:project_id] if params[:project_id]

    @conditions[:user_id] = @user.id if @user
    @conditions[:project_id] = @project.id if @project

    @url_params[:user_id] = @user.id if @user
    @url_params[:project_id] = @project.id if @project
  end

  # GET /user_time_records_feed.json
  def user_feed
    @conditions = {}
    @started_at = Time.at(params[:start].to_i)
    @ended_at = Time.at(params[:end].to_i)
    @conditions[:recorded_on] = (@started_at..@ended_at)

    @conditions[:user_id] = current_user.id
    @conditions[:type] = TimeRecord.name

    respond_to do |format|
      format.json { render json: TimeRecord.where(@conditions).collect{|t| t.to_user_feed}.to_json }
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
        format.json { render json: @time_record.to_json }
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
          started_at = nil
          time_record_data.each do |item|
            project = Project.find_by_name(item[:project_name]) || Project.create!(name: item[:project_name])
            project.users << @user unless project.users.include?(@user)
            started_at = DateTime.civil_from_format(:local, item[:recorded_on].year, item[:recorded_on].month, item[:recorded_on].day, 9) if started_at.nil? || !(started_at === item[:recorded_on])
            ended_at = item[:time_record].hours.since(started_at)

            lunch_break = (DateTime.civil_from_format(:local, started_at.year, started_at.month, started_at.day, Settings.time.working_hours.am.to)..DateTime.civil_from_format(:local, started_at.year, started_at.month, started_at.day, Settings.time.working_hours.pm.from))
            ranges = remove_lunch_break((started_at..ended_at), lunch_break)

            ranges.each do |range|

            # logger.debug('=====================================================')
            # logger.debug(started_at)
            # logger.debug(ended_at)
            # logger.debug(item[:recorded_on])

            # logger.debug(range.begin)
            # logger.debug(range.end)

              TimeRecord.find_by_user_id_and_project_id_and_started_at_and_ended_at(@user.id, project.id, range.begin, range.end) || TimeRecord.create!(
                {
                  user_id: @user.id,
                  project_id: project.id,
                  value: ((range.end.to_f - range.begin.to_f) / 3600).round,
                  recorded_on: DateTime.civil_from_format(:local, item[:recorded_on].year, item[:recorded_on].month, item[:recorded_on].day),
                  started_at: range.begin,
                  ended_at: range.end,
                  type: TimeRecord.name,
                  remark: '☻'
                })

            end

            started_at = ranges.last.end
          end
        end

        redirect_to upload_time_records_path, notice: "#{@user.name} #{TimeRecord.model_name.human} 上传完毕"
      else
        render :upload
      end
    end
  end

  def remove_lunch_break(range, lunch)
    return [range] if range.end <= lunch.begin
    return [range] if range.begin >= lunch.end

    if range.begin >= lunch.begin && range.begin <= lunch.end
      return [(lunch.end..Time.at(lunch.end.to_i - range.begin.to_i + range.end.to_i))]
    end

    if range.begin < lunch.begin
      return [(range.begin..lunch.begin), (lunch.end..1.hour.since(range.end))]
    end
  end
end
