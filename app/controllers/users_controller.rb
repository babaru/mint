class UsersController < ApplicationController
  before_filter :authenticate_user!
  # GET /users
  # GET /users.json
  def index
    @users_grid = initialize_grid(User)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users_grid }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def time_records
    @query_type = params[:type]
    @query_type ||= 'year'
    @query_type = @query_type.to_sym
    @query_type = :year unless [:week, :month, :year].include? @query_type
    @user = User.find(params[:user_id]) if params[:user_id]

    if @user
      case @query_type
      when :month
        @time_records_grid = initialize_grid(MonthlyTimeRecord.where(user_id: @user).order('user_id, project_id'))
      when :week
        @time_records_grid = initialize_grid(WeeklyTimeRecord.where(user_id: @user).order('user_id, project_id'))
      else # default :year
        @time_records_grid = initialize_grid(YearlyTimeRecord.where(user_id: @user).order('user_id, project_id'))
      end
    end
  end
end
