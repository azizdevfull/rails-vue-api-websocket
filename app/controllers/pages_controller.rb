class PagesController < ApplicationController
  def home
  end
  def say_hello
    @msg = params[:msg]
    ActionCable.server.broadcast 'alerts_channel', 'Your notification message'
    render json: { message: @msg }, status: :ok # "Hello, World!"
  end

  def send_notification
    @message = "Hello from Rails!"
    ActionCable.server.broadcast 'NotificationsChannel', @message
    render json: { message: @message }, status: :ok
  end
end
