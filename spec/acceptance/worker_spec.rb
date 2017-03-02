require 'acceptance_helper'

resource "工作台相关接口" do
  header "Accept", "application/json"
  worker_attrs = FactoryGirl.attributes_for(:worker)

  header "X-Worker-Token", worker_attrs[:authentication_token]
  header "X-Worker-Phone", worker_attrs[:phone]
  before do 
    # 创建价格表
    create_list(:store_method, 3)
    @stocking_chest = create(:stocking_chest) 
    @group_chest1 = create(:group_chest1)
    @alone_full_dress_chest = create(:alone_full_dress_chest)

    @worker = create(:worker)
    @user = create(:user)
    create(:user_info, user: @user)
  end

  describe 'appointment condition is all correct' do
    before do
      today_appointments = create_list(:appointment, 1, user: @user, date: Time.zone.today)
      tomorrow_appointments = create_list(:appointment, 1, user: @user, date: Time.zone.today + 1.days)
      @appointments = today_appointments.concat tomorrow_appointments
      @appointments.each do |appointment|

      end
    end

    get 'worker/appointments' do
      
      example "工作人员查询所有 预订订单 列表成功" do
        do_request
        puts response_body
        expect(status).to eq 200
      end
    end

    get 'worker/appointments/:id' do
      let(:id) { @appointments.first.id }

      example "工作人员查看指定预订订单详情成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    post '/worker/appointments/:id/accept' do
      let(:id) { @appointments.first.id }

      example "工作人员’接受‘指定预订订单成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    post '/worker/appointments/:id/storing' do
      let(:id) { @appointments.first.id }

      example "工作人员‘确认入库’指定预订订单成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    post '/worker/appointments/:id/cancel' do
      let(:id) { @appointments.first.id }

      example "工作人员‘取消’指定预订订单成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    put 'worker/appointments/:appointment_id' do
      parameter :count, "此栏选择的衣柜数量", required: true, scope: :appointment_item_group
      parameter :price_system_id
      parameter :store_month, "存放的月份数", required: true, scope: :appointment_item_group

      StoreMethod.all.each do |store_method|
        parameter store_month.title.to_sym, "#{store_method.zh_title}的数量", required: false, scope: [ :appointment_item_group, :garment_count_info ]
      end

      before do
        @appointments.first.accept!
      end
      
      example "工作人员修改指定订单下面的订单组成功" do
        params = {
          appointment_item: 
          {
            price_groups: [
              {
                price_system_id: @stocking_chest.id,
                count: 2,
                store_month: 3,
              },
              {
                count: 2,
                price: 300,
                store_month: 6,
                type_name: "裤装",
                season: '春秋'
              },
              {
                count: 3,
                price: 200,
                store_month: 12,
                type_name: '裙装',
                season: '四季'
              }
            ]
          }
        }
        # do_request params
        # puts response_body
        # expect(status).to eq(200)
      end
    end

    delete 'worker/appointments/:appointment_id' do
      let(:appointment_id) { @appointments.first.id }
      example "工作人员删除指定订单成功" do
        do_request
        puts response_body
        expect(status).to eq(204)
      end
    end

    get '/worker/appointments/state_query' do

      before do
        accepted_appointments = create_list(:appointment, 1, user: @user, aasm_state:"accepted")
        unpaid_appointments = create_list(:appointment, 1, user: @user, aasm_state:"unpaid")
        paid_appointments = create_list(:appointment, 1, user: @user, aasm_state:"paid")
        storing_appointments = create_list(:appointment, 1, user: @user, aasm_state:"storing")
        canceled_appointments = create_list(:appointment, 1, user: @user, aasm_state:"canceled")

        @appointments = accepted_appointments.concat (unpaid_appointments.concat (paid_appointments.concat (storing_appointments.concat canceled_appointments)))
        @appointments.each do |appointment|

        end
      end

      example "工作人员查看某个(‘服务中’,‘未付款’,‘已付款’,’入库中‘,'已取消')状态的预订订单列表成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

  describe '价格系统操作' do
    worker_attrs = FactoryGirl.attributes_for(:worker)

    header "X-User-Token", worker_attrs[:authentication_token]
    header "X-User-Phone", worker_attrs[:phone]

    before do
      @worker = create(:worker)
      @price_systems = create_list(:price_system, 5)
    end

    get 'work/price_systems' do

      parameter :page, "当前页", required: false
      parameter :per_page, "每页的数量", required: false

      let(:page) {2}
      let(:per_page) {2}

      example "工作人员查询价目列表成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    get 'work/price_systems/:id' do

      let(:id) {@price_systems.first.id}

      example "工作人员查询某价目详细信息成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

  end
end
end