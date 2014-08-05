class LeaveRecorderController < ApplicationController
  layout 'recorder'

  def index
    @title = LeaveRecord.model_name.human
  end
end
