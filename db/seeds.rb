user = User.create!(name: "Admin", email: "admin@admin.com", password: "adm123")
verde = Room.create!(label: "Verde")
azul = Room.create!(label: "Azul")
Booking.create!(
  user: user,
  room: verde,
  title: "Daily meeting",
  datetime_start: Time.zone.now.beginning_of_day + 12.hours,
  datetime_end: Time.zone.now.beginning_of_day + 14.hours,
)
