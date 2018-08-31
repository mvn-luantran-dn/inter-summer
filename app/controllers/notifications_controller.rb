class NotificationsController < ApplicationController
  def change
    Notification.where(user_id: params[:id]).update(status: 0)
    respond_to do |format|
      format.json { render json: 'success'.to_json }
    end
  end
end
