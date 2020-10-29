class BookingsController < ApplicationController
  def index
    render json: RoomBookingsService.new.call(params[:room_id])
  end

  def create
    Booking.create!(
      title: params[:title],
      room_id: params[:room_id],
      user: @current_user,
      datetime_start: params[:datetime_start],
      datetime_end: params[:datetime_end],
    )
    head :created
  end
end
