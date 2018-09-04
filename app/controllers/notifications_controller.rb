class NotificationsController < ApplicationController
  def change
    respond_to do |format|
      Notification.where(user_id: params[:id]).update(status: 0)
      format.json { render json: 'success'.to_json }
    end
  end
end
