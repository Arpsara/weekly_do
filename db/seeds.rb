# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Role.create(name: "super_admin")
Role.create(name: "admin")

CalendarParameter.create(schedules_nb_per_day: 10,
  open_days: [1,2,3,4,5])
