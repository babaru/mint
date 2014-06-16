class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def after_sign_in_path_for(resource)
    if resource.is_sys_admin?
      return dashboard_path
    else
      return personal_time_recorder_path
    end
  end
end
