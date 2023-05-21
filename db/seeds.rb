# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.destroy_all
BookingType.destroy_all

user = User.create!(
  booking_link: "jameswood",
  name: "James Wood",
  email: "james@gmail.com",
  password: "password",
  password_confirmation: "password",
)

bookin_type1 = BookingType.create!(
  user: user,
  name: "15 Minute Meeting",
  location: "Zoom",
  description: "A 15 minute meeting with James Wood",
  color: "#2ecc71",
  duration: 15,
  payment_required: false,
  price: nil,
)

bookin_type2 = BookingType.create!(
  user: user,
  name: "30 Minute Meeting",
  location: "Zoom",
  description: "A 30 minute meeting with James Wood",
  color: "#3498db",
  duration: 30,
  payment_required: true,
  price: 5,
)

bookin_type3 = BookingType.create!(
  user: user,
  name: "60 Minute Meeting",
  location: "Zoom",
  description: "A 1 hour meeting with James Wood",
  color: "#e4a241",
  duration: 60,
  payment_required: true,
  price: 10,
)

puts "Created #{User.count} users"
puts "Created #{BookingType.count} booking types"
