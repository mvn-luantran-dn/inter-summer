# frozen_string_literal: true

module UsersHelper
  def admin_user?
    current_user.role == 'admin'
  end
end
