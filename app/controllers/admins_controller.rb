class AdminsController < ApplicationController
  before_filter :admin_check
  layout "admin/administrations"
  def admin_check
    if current_user.present? && current_user.is_admin?
    else
      redirect_to root_path
      flash[:notice] = "You are not an administrator."
    end
  end
end
