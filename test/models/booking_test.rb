require "test_helper"

class BookingTest < ActiveSupport::TestCase
  test "validate datetime" do
    booking = Booking.new
    booking.validate
    assert booking.errors[:datetime_start].present?
    assert booking.errors[:datetime_end].present?

    # same date
    booking.datetime_start = "2020-10-10 12:00:00"
    booking.datetime_end = "2020-10-10 12:00:00"
    booking.validate
    assert booking.errors[:datetime_start].present?

    # end before start
    booking.datetime_end = "2020-10-10 11:00:00"
    booking.validate
    assert booking.errors[:datetime_start].present?

    # correct time
    booking.datetime_end = "2020-10-10 13:00:00"
    booking.validate
    assert booking.errors[:datetime_start].blank?

    # time after business time
    booking.datetime_end = "2020-10-10 18:00:01"
    booking.validate
    assert booking.errors[:datetime_end].present?

    # time at limit business time
    booking.datetime_end = "2020-10-10 18:00:00"
    booking.validate
    assert booking.errors[:datetime_end].blank?

    # time before business time
    booking.datetime_start = "2020-10-10 07:59:59"
    booking.validate
    assert booking.errors[:datetime_start].present?

    # time at business time
    booking.datetime_start = "2020-10-10 08:00:00"
    booking.validate
    assert booking.errors[:datetime_start].blank?
  end

  test "validate uniqueness booking for room" do
    Booking.delete_all
    user = User.create!(name: "Test", email: "test@test.com", password: "test123")
    room = Room.create!(label: "Meeting")

    Booking.create!(
      title: "Morning",
      user: user,
      room: room,
      datetime_start: "2020-12-30 09:00:00",
      datetime_end: "2020-12-30 11:00:00",
    )

    Booking.create!(
      title: "Afternoon",
      user: user,
      room: room,
      datetime_start: "2020-12-30 13:00:00",
      datetime_end: "2020-12-30 17:00:00",
    )

    booking = Booking.new(
      title: "Invalid start",
      user: user,
      room: room,
      datetime_start: "2020-12-30 10:00:00",
      datetime_end: "2020-12-30 12:00:00",
    )
    booking.validate
    assert booking.errors[:datetime_start].present?

    booking.datetime_start = "2020-12-30 11:00:00"
    booking.datetime_end = "2020-12-30 14:00:00"
    booking.validate
    assert booking.errors[:datetime_end].present?

    booking.datetime_end = "2020-12-30 18:00:00"
    booking.validate
    assert booking.errors[:datetime_end].present?

    booking.datetime_end = "2020-12-30 13:00:00"
    booking.validate
    assert booking.errors[:datetime_start].blank?
    assert booking.errors[:datetime_end].blank?
  end
end
