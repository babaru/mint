class OvertimeRecorderController < ApplicationController
  layout 'recorder'

  def index
    @title = OvertimeRecord.model_name.human
  end
end
