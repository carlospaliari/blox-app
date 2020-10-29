class RoomBookingsService
  def call(room_id)
    Room.find(room_id).bookings.order(:datetime_start)
  end
end
