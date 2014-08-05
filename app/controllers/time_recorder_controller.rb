class TimeRecorderController < ApplicationController
  layout 'recorder'
  before_filter :authenticate_user!

  def index
    @title = TimeRecord.model_name.human
  end
end
