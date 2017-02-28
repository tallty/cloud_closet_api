# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
StoreMethod.create!(
	[
		{ id: 1, title: "hanging", zh_title: "挂件"},
		{ id: 2, title: "stacking", zh_title: "叠放件"},
		{ id: 3, title: "full_dress", zh_title: "礼服"},
		])		
