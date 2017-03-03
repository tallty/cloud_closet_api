# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars', price_system_id: 1 }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

StoreMethod.destroy_all
StoreMethod.create!(
	[
		{ id: 1, title: "hanging", zh_title: "挂件"},
		{ id: 2, title: "stacking", zh_title: "叠放件"},
		{ id: 3, title: "full_dress", zh_title: "礼服"},
		])	


PriceSystem.destroy_all
PriceSystem.create!(
	[
		{ id: 1, title: '叠放柜', price: 180, description: '叠放柜可存放针织类，卫衣棉服等可折叠衣物60件, 也可提供真空袋出售', is_chest: true, unit_name: '月' },
		{ id: 2, title: '挂柜', price: 180, description: '叠放柜可存放针织类，卫衣棉服等可折叠衣物60件, 也可提供真空袋出售', is_chest: true, unit_name: '月' },
		{ id: 3, title: '组合柜', price: 400, description: '*组合柜可存放60件折叠和20件挂放', is_chest: true, unit_name: '月' },
		{ id: 4, title: '单件礼服', price: 60, description: '我是单件礼服 ,每月60', is_chest: true, unit_name: '月' },
		{ id: 5, title: '礼服柜', price: 60, description: '	礼服柜可存放12件贵重礼服，适合存放大件礼服；', is_chest: true, unit_name: '月' },
		{ id: 6, title: '真空袋-中', price: 10, description: '我是真空袋中号', is_chest: false, unit_name: '个' },
		{ id: 7, title: '真空袋-大', price: 10, description: '我是真空袋大号', is_chest: false, unit_name: '个' }
		])		
ExhibitionUnit.destroy_all
ExhibitionUnit.create!  (
	[
		{ id: 1, title: "叠放柜", store_method: "stacking", max_count: 60, need_join: false, price_system_id: 1 },
		{ id: 2, title: "挂柜", store_method: "hanging", max_count: 20, need_join: false, price_system_id: 2 },
		{ id: 3, title: "组合柜-叠放柜", store_method: "stacking", max_count: 60, need_join: false, price_system_id: 3 },
		{ id: 4, title: "组合柜-挂柜", store_method: "hanging", max_count: 20, need_join: false, price_system_id: 3 },
		{ id: 6, title: "单件礼服", store_method: 'full_dress', max_count: 1, need_join: true, price_system_id: 4 },
		{ id: 5, title: "礼服柜", store_method: 'full_dress', max_count: 12, need_join: false, price_system_id: 5 },
		
		])
# user = User.where(phone: '18516591232').first
# @appointment = Appointment.create(user: user, number: 50, date: "2016-09-24", care_cost: 111, care_type: '普通护理', service_cost: 222)
# AppointmentPriceGroup.create(appointment: @appointment, price_system: PriceSystem.find(1), count: 1, store_month: 3)
# AppointmentPriceGroup.create(appointment: @appointment, price_system: PriceSystem.find(2), count: 3, store_month: 3)
# AppointmentPriceGroup.create(appointment: @appointment, price_system: PriceSystem.find(3), count: 1, store_month: 3)
# AppointmentPriceGroup.create(appointment: @appointment, price_system: PriceSystem.find(4), count: 1, store_month: 3)
# AppointmentPriceGroup.create(appointment: @appointment, price_system: PriceSystem.find(5), count: 4, store_month: 2)
# AppointmentPriceGroup.create(appointment: @appointment, price_system: PriceSystem.find(6), count: 1, store_month: 0)
    
    
 

    
 

    
 

    
 
 