class Booking < ApplicationRecord
  BUSINESS_TIME = "8:00".."18:00"

  belongs_to :user
  belongs_to :room

  validates :title, presence: true
  validates :datetime_start, :datetime_end, timeliness: true
  validates :datetime_start, timeliness: { before: :datetime_end }
  validates :datetime_end, timeliness: { after: :datetime_start }
  validates_time :datetime_start, :datetime_end, between: BUSINESS_TIME
  validate :datetime_start_booked_for_room_validation
  validate :datetime_end_booked_for_room_validation
  validate :between_datetime_for_room_validation

  def datetime_start_booked_for_room?
    return false unless datetime_start && room
    self.class
      .where(room: room)
      .where("datetime_start <= ?", datetime_start)
      .where("? < datetime_end", datetime_start)
      .exists?
  end

  def datetime_end_booked_for_room?
    return false unless datetime_end && room
    self.class
      .where(room: room)
      .where("datetime_start < ?", datetime_end)
      .where("? <= datetime_end", datetime_end)
      .exists?
  end

  def datetime_booked_for_room?
    return false unless datetime_start && datetime_end && room
    self.class
      .where(room: room)
      .where("datetime_start >= ?", datetime_start)
      .where("datetime_end <= ?", datetime_end)
      .exists?
  end

  private

  def datetime_start_booked_for_room_validation
    errors.add(:datetime_start, "already booked for this room") if datetime_start_booked_for_room?
  end

  def datetime_end_booked_for_room_validation
    errors.add(:datetime_end, "already booked for this room") if datetime_end_booked_for_room?
  end

  def between_datetime_for_room_validation
    errors.add(:datetime_end, "already booked for this room") if datetime_booked_for_room?
  end
end
