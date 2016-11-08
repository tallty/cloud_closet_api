require 'acceptance_helper'

resource "按条件查询价目" do
  header "Accept", "application/json"

  get 'query_price_systems' do

  	parameter :name, "价目名称,中文字符串，多条件以 中文全角逗号 隔开", required: false
  	parameter :season, "季节,中文字符串，多条件 以中文全角逗号 隔开", require: false

  	before do
	  	create(:price_system, name: "上衣", season: "春")
	  	create(:price_system, name: "上衣", season: "夏")
	  	create(:price_system, name: "裤装", season: "春")
	  	create(:price_system, name: "裙装", season: "春")
	  	create(:price_system, name: "帽子", season: "秋") 
		end

		let(:name) {}
		let(:season) {"春，夏"}

		example "按条件查询价目表,无参数则默认查询所有" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end

	end
end
