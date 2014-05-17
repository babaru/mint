class TimeSheetsController < ApplicationController
  include Mint::Calculators::TimeSheetCalculator
  # GET /time_sheets
  # GET /time_sheets.json
  def index
    default_start_date = Date.today.beginning_of_week
    default_end_date = Date.today.end_of_week
    if request.post?
      @url_params = {}
      @url_params[:user_id] = params[:user_id] if params[:user_id]
      @url_params[:project_id] = params[:project_id] if params[:project_id]
      @url_params[:start_date] = params[:date_range][:start_date] if params[:date_range] && params[:date_range][:start_date] && !params[:date_range][:start_date].empty?
      @url_params[:end_date] = params[:date_range][:end_date] if params[:date_range] && params[:date_range][:end_date]
      redirect_to time_sheets_path(@url_params)
    else
      @url_params = {}
      @user = User.find params[:user_id] if params[:user_id]
      @project = Project.find params[:project_id] if params[:project_id]
      @conditions = {}
      @conditions[:user_id] = @user.id if @user
      @url_params[:user_id] = @user.id if @user
      @conditions[:project_id] = @project.id if @project
      @url_params[:project_id] = @project.id if @project
      @start_date = default_start_date
      unless params[:start_date].nil? || params[:start_date].empty?
        @start_date = Date.parse(params[:start_date])
      end
      @end_date = default_end_date
      unless params[:end_date].nil? || params[:end_date].empty?
        @end_date = Date.parse(params[:end_date])
      end

      @conditions[:recorded_on] = (@start_date.beginning_of_day..@end_date.end_of_day)
      @url_params[:start_date] = @start_date.strftime("%Y-%m-%d")
      @url_params[:end_date] = @end_date.strftime("%Y-%m-%d")

      @time_sheets_grid = initialize_grid(TimeSheet.where(@conditions), name: 'details_grid')
      @total_time_sheet = TimeSheet.select([
          Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:calculated_hours]]).as('calculated_hours'),
          Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:overtime_hours]]).as('overtime_hours'),
          Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:recorded_hours]]).as('recorded_hours'),
          Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:calculated_normal_hours]]).as('calculated_normal_hours'),
          Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:calculated_overtime_hours]]).as('calculated_overtime_hours'),
          Arel::Nodes::NamedFunction.new('MAX', [TimeSheet.arel_table[:recorded_on]]).as('recorded_on')
        ]).where(@conditions).first

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @time_sheets_grid }
      end
    end
  end

  def users
    @conditions, @url_params = {}, {}

    @report_kind = params[:kind]
    @report_kind ||= 'personal'
    @report_kind = @report_kind.to_sym
    @url_params[:kind] = @report_kind

    @report_duration = params[:duration]
    @report_duration ||= 'week'
    @report_duration = @report_duration.to_sym
    @url_params[:duration] = @report_duration

    @week_number = params[:week].to_i if params[:week]
    @week_number ||= Date.today.strftime("%U").to_i + 1
    @url_params[:week] = @week_number

    @month_number = params[:month].to_i if params[:month]
    @month_number ||= Date.today.strftime("%m").to_i
    @url_params[:month] = @month_number

    @year_number = params[:year].to_i if params[:year]
    @year_number ||= Date.today.strftime("%Y").to_i
    @url_params[:year] = @year_number

    case @report_duration
    when :year
      start_date = Date.new(@year_number, 1, 1)
      end_date = Date.new(@year_number, 12, 31)
      @conditions[:recorded_on] = (start_date.beginning_of_day..end_date.end_of_day)
    when :month
      start_date = Date.new(@year_number, @month_number, 1)
      end_date = Date.new(@year_number, @month_number, -1)
      @conditions[:recorded_on] = (start_date.beginning_of_day..end_date.end_of_day)
    when :week
      start_date = Date.commercial(@year_number, @week_number, 1)
      end_date = Date.commercial(@year_number, @week_number, 7)
      @conditions[:recorded_on] = (start_date.beginning_of_day..end_date.end_of_day)
    else
      start_date = Date.new(2000,1,1)
      end_date = Date.today
      @conditions[:recorded_on] = (start_date.beginning_of_day..end_date.end_of_day)
    end

    @user = User.find params[:user_id] if params[:user_id]
    @project = Project.find params[:project_id] if params[:project_id]

    @conditions[:user_id] = @user.id if @user
    @conditions[:project_id] = @project.id if @project

    @url_params[:user_id] = @user.id if @user
    @url_params[:project_id] = @project.id if @project

    if @user.nil?
      @personal_time_reports = User.tracking.order('name').inject([]) do |list, user|
        list << {
          user: user,
          grid: initialize_grid(TimeSheet.select([
            Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:calculated_hours]]).as('calculated_hours'),
            Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:overtime_hours]]).as('overtime_hours'),
            Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:recorded_hours]]).as('recorded_hours'),
            Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:calculated_normal_hours]]).as('calculated_normal_hours'),
            Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:calculated_overtime_hours]]).as('calculated_overtime_hours'),
            :project_id,
            :user_id
          ]).where(@conditions.merge({user_id: user.id})).group(:user_id, :project_id), name: "#{user.id}_time_report_grid")
        }
      end
    else
      @personal_time_report_grid = initialize_grid(TimeSheet.select([
            Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:calculated_hours]]).as('calculated_hours'),
            Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:overtime_hours]]).as('overtime_hours'),
            Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:recorded_hours]]).as('recorded_hours'),
            Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:calculated_normal_hours]]).as('calculated_normal_hours'),
            Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:calculated_overtime_hours]]).as('calculated_overtime_hours'),
            :project_id,
            :user_id
          ]).where(@conditions).group(:user_id, :project_id), name: "#{@user.id}_time_report_grid")
    end
  end

  def projects
    @conditions, @url_params = {}, {}

    @report_duration = params[:duration]
    @report_duration ||= 'week'
    @report_duration = @report_duration.to_sym
    @url_params[:duration] = @report_duration

    @week_number = params[:week].to_i if params[:week]
    @week_number ||= Date.today.strftime("%U").to_i + 1
    @url_params[:week] = @week_number

    @month_number = params[:month].to_i if params[:month]
    @month_number ||= Date.today.strftime("%m").to_i
    @url_params[:month] = @month_number

    @year_number = params[:year].to_i if params[:year]
    @year_number ||= Date.today.strftime("%Y").to_i
    @url_params[:year] = @year_number

    case @report_duration
    when :year
      start_date = Date.new(@year_number, 1, 1)
      end_date = Date.new(@year_number, 12, 31)
      @conditions[:recorded_on] = (start_date.beginning_of_day..end_date.end_of_day)
    when :month
      start_date = Date.new(@year_number, @month_number, 1)
      end_date = Date.new(@year_number, @month_number, -1)
      @conditions[:recorded_on] = (start_date.beginning_of_day..end_date.end_of_day)
    when :week
      start_date = Date.commercial(@year_number, @week_number, 1)
      end_date = Date.commercial(@year_number, @week_number, 7)
      @conditions[:recorded_on] = (start_date.beginning_of_day..end_date.end_of_day)
    else
      start_date = Date.new(2000,1,1)
      end_date = Date.today
      @conditions[:recorded_on] = (start_date.beginning_of_day..end_date.end_of_day)
    end

    @project = Project.find params[:project_id] if params[:project_id]

    @conditions[:project_id] = @project.id if @project

    @url_params[:project_id] = @project.id if @project

    @project_time_sheet_grid = initialize_grid(TimeSheet.select([
      Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:calculated_hours]]).as('calculated_hours'),
      Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:overtime_hours]]).as('overtime_hours'),
      Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:recorded_hours]]).as('recorded_hours'),
      Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:calculated_normal_hours]]).as('calculated_normal_hours'),
      Arel::Nodes::NamedFunction.new('SUM', [TimeSheet.arel_table[:calculated_overtime_hours]]).as('calculated_overtime_hours'),
      :project_id
    ]).where(@conditions).group(:project_id), per_page: 50)
  end

  # GET /time_sheets/1
  # GET /time_sheets/1.json
  def show
    @time_sheet = TimeSheet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @time_sheet }
    end
  end

  # GET /time_sheets/new
  # GET /time_sheets/new.json
  def new
    @time_sheet = TimeSheet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @time_sheet }
    end
  end

  # GET /time_sheets/1/edit
  def edit
    @time_sheet = TimeSheet.find(params[:id])
  end

  # POST /time_sheets
  # POST /time_sheets.json
  def create
    @time_sheet = TimeSheet.new(params[:time_sheet])

    respond_to do |format|
      if @time_sheet.save
        format.html { redirect_to time_sheets_path, notice: 'Time sheet was successfully created.' }
        format.json { render json: @time_sheet, status: :created, location: @time_sheet }
      else
        format.html { render action: "new" }
        format.json { render json: @time_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_sheets/1
  # PATCH/PUT /time_sheets/1.json
  def update
    @time_sheet = TimeSheet.find(params[:id])

    respond_to do |format|
      if @time_sheet.update_attributes(params[:time_sheet])
        format.html { redirect_to time_sheets_path, notice: 'Time sheet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @time_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_sheets/1
  # DELETE /time_sheets/1.json
  def destroy
    @time_sheet = TimeSheet.find(params[:id])
    @time_sheet.destroy

    respond_to do |format|
      format.html { redirect_to time_sheets_url }
      format.json { head :no_content }
    end
  end

  def calculate
    if request.post?

      users = []

      unless params[:time_sheet].nil? || params[:time_sheet][:user_id].nil? ||
        params[:time_sheet][:user_id].empty?
        users = [User.find(params[:time_sheet][:user_id])]
      else
        users = User.tracking
      end

      start_date = Date.today.beginning_of_week
      unless params[:time_sheet].nil? || params[:time_sheet][:start_date].nil? ||
        params[:time_sheet][:start_date].empty?
        start_date = Date.parse(params[:time_sheet][:start_date])
      end

      end_date = Date.today.end_of_week
      unless params[:time_sheet].nil? || params[:time_sheet][:end_date].nil? ||
        params[:time_sheet][:end_date].empty?
        end_date = Date.parse(params[:time_sheet][:end_date])
      end

      TimeRecord.transaction do

        Project.migrate_children_time_records
        Project.children.each {|child| TimeSheet.delete_all(project_id: child.id)}

        users.each do |user|
          user_id = user.id

          (start_date..end_date).each do |recorded_on|
            overtime_record = OvertimeRecord.find_by_user_id_and_happened_at(user_id, recorded_on)
            time_records = TimeRecord.where(user_id: user_id, recorded_on: recorded_on)

            calculated_results = calculate_time_sheet(time_records, overtime_record)

            calculated_results.each do |item|
              time_sheet = TimeSheet.find_by_user_id_and_project_id_and_recorded_on(user_id, item[:project_id], (recorded_on.beginning_of_day..recorded_on.end_of_day))
              unless time_sheet.nil?
                time_sheet.update_attributes!({
                  calculated_hours: item[:calculated_hours],
                  overtime_hours: item[:overtime_hours],
                  recorded_hours: item[:recorded_hours],
                  calculated_normal_hours: item[:calculated_normal_hours],
                  calculated_overtime_hours: item[:calculated_overtime_hours]
                })
              else
                time_sheet = TimeSheet.create!({
                  user_id: user_id,
                  project_id: item[:project_id],
                  recorded_on: recorded_on,
                  calculated_hours: item[:calculated_hours],
                  overtime_hours: item[:overtime_hours],
                  recorded_hours: item[:recorded_hours],
                  calculated_normal_hours: item[:calculated_normal_hours],
                  calculated_overtime_hours: item[:calculated_overtime_hours]
                })
              end
              time_sheet.overtime_record = overtime_record if time_sheet.overtime_record.nil?
              time_sheet.time_records.clear
              item[:time_records].each {|tr| time_sheet.time_records << tr unless time_sheet.time_records.include?(tr)}
            end
          end
        end
      end

      redirect_to calculate_time_sheets_path, notice: "#{TimeSheet.model_name.human} was successfully calculated."
    end
  end
end
