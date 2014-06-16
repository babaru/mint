class ProjectLogsController < ApplicationController
  # GET /project_logs
  # GET /project_logs.json
  def index
    @project_logs_grid = initialize_grid(ProjectLog)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_logs_grid }
    end
  end

  # GET /project_logs/1
  # GET /project_logs/1.json
  def show
    @project_log = ProjectLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project_log }
    end
  end

  # GET /project_logs/new
  # GET /project_logs/new.json
  def new
    @project_log = ProjectLog.new
    @project_log.project_id = params[:project_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project_log }
    end
  end

  # GET /project_logs/1/edit
  def edit
    @project_log = ProjectLog.find(params[:id])
  end

  # POST /project_logs
  # POST /project_logs.json
  def create
    @project_log = ProjectLog.new(params[:project_log])

    respond_to do |format|
      if @project_log.save
        format.html { redirect_to project_path(@project_log.project_id), notice: 'Project log was successfully created.' }
        format.json { render json: @project_log, status: :created, location: @project_log }
      else
        format.html { render action: "new" }
        format.json { render json: @project_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_logs/1
  # PATCH/PUT /project_logs/1.json
  def update
    @project_log = ProjectLog.find(params[:id])

    respond_to do |format|
      if @project_log.update_attributes(params[:project_log])
        format.html { redirect_to project_path(@project_log.project_id), notice: 'Project log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_logs/1
  # DELETE /project_logs/1.json
  def destroy
    @project_log = ProjectLog.find(params[:id])
    project_id = @project_log.project_id
    @project_log.destroy

    respond_to do |format|
      format.html { redirect_to project_path(project_id) }
      format.json { head :no_content }
    end
  end
end
