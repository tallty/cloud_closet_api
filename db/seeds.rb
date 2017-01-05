# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all 
User.create!(phone: '13813813811', password: 'qwertyuiop', 
	         password_confirmation: 'qwertyuiop',authentication_token:'qwertyuiop')
Admin.destroy_all
Admin.create!(email: 'admin@example.com', password: 'password', 
	          password_confirmation: 'password', authentication_token:'qwertyuiop1')