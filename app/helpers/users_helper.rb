module UsersHelper
  def admin_user?
    current_user.role == 'admin'
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end

  def admin_user
    unless current_user.role == 'admin'
      flash[:danger] = 'Error'
      redirect_to login_url
    end
  end
end
