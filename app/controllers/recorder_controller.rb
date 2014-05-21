class RecorderController < ApplicationController
  layout 'recorder'

  before_filter :authenticate_user!

  def index

  end
end
