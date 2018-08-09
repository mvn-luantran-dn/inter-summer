# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  before_action :logged_in_user
  layout 'admin/application'

  def index; end

  def logged_in_user
    unless logged_in?
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end
end
