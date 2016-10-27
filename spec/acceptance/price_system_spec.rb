require 'acceptance_helper'

resource "价格系统" do
  header "Accept", "application/json"

  describe '价格系统操作' do
    admin_attrs = FactoryGirl.attributes_for(:admin)
  	price_system_attrs = FactoryGirl.attributes_for(:price_system)

    header "X-Admin-Token", admin_attrs[:authentication_token]
    header "X-Admin-Email", admin_attrs[:email]

    before do
      @admin = create(:admin)
      @price_systems = create_list(:price_system, 5)
    end

	  get '/price_systems' do

	    parameter :page, "当前页", require: false
	    parameter :per_page, "每页的数量", require: false

	    let(:page) {2}
	    let(:per_page) {2}

	    example "管理员查询价目列表成功" do
	      do_request
	      puts response_body
	      expect(status).to eq(200)
	    end
	  end

	  get '/price_systems/:id' do

	    let(:id) {@price_systems.first.id}

	    example "管理员查询某价目详细信息成功" do
	      do_request
	      puts response_body
	      expect(status).to eq(200)
	    end
	  end

	  post '/price_systems' do

	    let(:id) {@price_systems.first.id}

		  parameter :name, "价目的衣服类型名称", require: true, scope: :price_system
	    parameter :season, "价目的衣服季节", require: true, scope: :price_system
	    parameter :price, "价目的单价", require: true, scope: :price_system

	    let(:name) { price_system_attrs[:name] }
	    let(:season) { price_system_attrs[:season] }
	    let(:price) { price_system_attrs[:price] }

	    example "管理员创建价目信息成功" do
	      do_request
	      puts response_body
	      expect(status).to eq(201)
	    end
	  end

	  put '/price_systems/:id' do

	    let(:id) {@price_systems.first.id}

		  parameter :name, "价目的衣服类型名称", require: false, scope: :price_system
	    parameter :season, "价目的衣服季节", require: false, scope: :price_system
	    parameter :price, "价目的单价", require: false, scope: :price_system

	    let(:name) { "new 上衣" }
	    let(:season) { "new 春夏" }
	    let(:price) { "new 32" }

	    example "管理员修改某价目信息成功" do
	      do_request
	      puts response_body
	      expect(status).to eq(201)
	    end
	  end

	  delete '/price_systems/:id' do

      let(:id) {@price_systems.first.id}

      example "管理员删除某价目成功" do
        do_request
        puts response_body
        expect(status).to eq(204)
      end
    end

  end
end