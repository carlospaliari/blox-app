class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :room, foreign_key: true
      t.string :title
      t.datetime :datetime_start
      t.datetime :datetime_end

      t.timestamps
    end
  end
end
