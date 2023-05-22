module BookingTypesHelper
  def duration(booking_type)
    hours = booking_type.duration / 60
    if booking_type.duration < 60
      "#{booking_type.duration} minutes"
    elsif booking_type.duration == 60
      "1 hour"
    else
      if booking_type.duration % 60 == 0
        "#{hours} #{(hours == 1) ? 'hour' : 'hours'}"
      else
        "#{hours} #{(hours == 1) ? 'hour' : 'hours'} #{booking_type.duration % 60} minutes"
      end
    end
  end
end
