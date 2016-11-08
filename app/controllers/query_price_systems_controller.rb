class QueryPriceSystemsController < ApplicationController

	def query_price_systems
		_name = params[:name] ? params[:name].split("，") : PriceSystem.all.collect(&:name)
		_season = params[:season] ? params[:season].split("，") : PriceSystem.all.collect(&:season)

		@price_systems = PriceSystem.price_system_name(_name).price_system_season(_season)

		respond_with @price_systems, template: "price_systems/index", status: 200
	end

end