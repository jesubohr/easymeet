class Booking < ApplicationRecord
  has_person_name
  belongs_to :booking_type
  belongs_to :user
  has_rich_text :notes
end
