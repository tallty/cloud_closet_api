require 'acceptance_helper'

resource "工作台相关接口" do
  header "Accept", "application/json"
  before do 
    create_list(:vip_level, 4)
    # 创建价格表
    @store_methods = create_list(:store_method, 3)
    @stocking_chest = create(:stocking_chest) 
    @group_chest1 = create(:group_chest1)
    @alone_full_dress_chest = create(:alone_full_dress_chest)
    @vacuum_bag_medium = create(:vacuum_bag_medium)

    @worker = create(:worker)
    @user = create(:user)
    create(:user_info, user: @user)

    header "X-Worker-Token", @worker.authentication_token
    header "X-Worker-Phone", @worker.phone
    allow_any_instance_of(WechatMessageService).to receive(:send_msg) {
      @sent = true
    }
  end

   describe 'worker authentication' do

    before do
      header "X-Worker-Token", nil
      header "X-Worker-Phone", nil
    end

    post "/workers/sign_in" do

      parameter :phone, "登录的手机号", required: true, scope: :worker
      parameter :password, "登录密码", required: true, scope: :worker

      let(:phone) { @worker.phone }
      let(:password) { @worker.password }

      response_field :id, "工作人员ID"
      response_field :phone, "手机号"
      response_field :created_at, "创建时间"
      response_field :updated_at, "更新时间"
      response_field :authentication_token, "鉴权Token"

      example "工作人员登录成功" do
        p @worker
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end
  end

  describe 'appointment condition is all correct' do
    before do
      today_appointments = create_list(:appointment, 1, user: @user, date: Time.zone.today)
      tomorrow_appointments = create_list(:appointment, 1, user: @user, date: Time.zone.today + 1.days)
      @appointments = today_appointments.concat tomorrow_appointments
      @appointments.each do |appointment|
         create(:appointment_price_group, 
          appointment: appointment,
          price_system: @alone_full_dress_chest

          )
      end
      # p '@user.valuation_chests'
      # p @user.valuation_chests
      # p '@user.exhibition_chests'
      # p @user.exhibition_chests
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
      parameter :remark, '备注', required: false, scope: :appointment     
      parameter :care_type, '护理类型', required: true, scope: :appointment        
      parameter :care_cost, '护理费用', required: true, scope: :appointment        
      parameter :service_cost, '服务费', required: true, scope: :appointment

      parameter :count, "price_group 此栏选择的衣柜/真空袋数量", required: true, scope: [ :appointment_items, :price_groups ]
      parameter :price_system_id, '价格 price_system id', required: true, scope: [ :appointment_items, :price_groups ]
      parameter :store_month, "存放的月份数", required: false, scope: [ :appointment_items, :price_groups ]
      parameter :hanging, "挂放数量", required: false, scope: [ :appointment_items, :price_groups ]
      parameter :stacking, "叠放数量", required: false, scope: [ :appointment_items, :price_groups ]
      parameter :full_dress, "礼服数量", required: false, scope: [ :appointment_items, :price_groups ]

      # @store_methods.each do |store_method|
      #   p '-----'
      #   p parameter store_method.title.to_sym, "#{store_method.zh_title}的数量", required: false, scope: [ :appointment, :garment_count_info ]
      # end

      before do
        @appointments.first.accept!
        @store_methods = create_list(:store_method, 3)
      end

      let(:appointment_id) { @appointments.first.id }

      example "工作人员修改指定订单下面的订单组成功" do
        params = {
          appointment:
            {
              remark: '我是备注',
              care_type: '普通护理',
              care_cost: 100,
              service_cost: 200,
              garment_count_info: 
                {
                  hanging: 0,
                  stacking: 0
                }
            },
          appointment_items: 
            {
              price_groups: [
                {
                  price_system_id: @stocking_chest.id,
                  count: 1,
                  store_month: 3,
                },
                {
                  price_system_id: @group_chest1.id,
                  count: 2,
                  store_month: 4,
                },
                {
                  price_system_id: @vacuum_bag_medium.id,
                  count: 2,
                  store_month: 2,
                },
                {
                  price_system_id: @alone_full_dress_chest.id,
                  count: 4,
                  store_month: 6,
                },
              ]
            }
        }

        do_request params
        puts response_body
        expect(status).to eq(200)
      end
      describe '失败' do 
        # example "【工作人员】修改指定订单下面的订单组 失败（选择的衣橱空间数量不足）" do
        #   params = {
        #     appointment:
        #       {
        #         remark: '我是备注',
        #         care_type: '普通护理',
        #         care_cost: 100,
        #         service_cost: 200,
        #         garment_count_info: 
        #           {
        #             hanging: 10000,
        #             stacking: 55
        #           }
        #       },
        #     appointment_items: 
        #       {
        #         price_groups: [
        #           {
        #             price_system_id: @stocking_chest.id,
        #             count: 1,
        #             store_month: 3,
        #           },
        #           {
        #             price_system_id: @group_chest1.id,
        #             count: 2,
        #             store_month: 4,
        #           },
        #           {
        #             price_system_id: @vacuum_bag_medium.id,
        #             count: 2,
        #             store_month: 2,
        #           },
        #           {
        #             price_system_id: @alone_full_dress_chest.id,
        #             count: 4,
        #             store_month: 6,
        #           },
        #         ]
        #       }
        #   }

        #   do_request params
        #   puts response_body
        #   expect(status).to eq(422)
        # end
      end
    end

    delete 'worker/appointments/:appointment_id' do
      let(:appointment_id) { @appointments.first.id }
      example '工作人员删除指定订单成功' do
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

        @appointments = accepted_appointments.concat(unpaid_appointments.concat(paid_appointments.concat (storing_appointments.concat canceled_appointments)))
      end

      example "工作人员查看某个(‘服务中’,‘未付款’,‘已付款’,’入库中‘,'已取消')状态的预订订单列表成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

  end

  describe '线下充值' do

    before do 
      SmsToken.create(auth_key: "worker-#{@worker.phone}-1000", token: '1111')
      @offline_recharges = create_list(
          :offline_recharge, 3,
          amount: 1000,
          user: @user,
          worker: @worker,
          auth_code: '1111'
        )
      allow(SmsToken).to receive(:send_msg)  {
        {"code"=>0, "msg"=>nil, "detail"=>""}
      }
    end

    get 'worker/offline_recharges' do

      example "工作人员查询 充值规则 价目列表 成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    post 'worker/offline_recharges/get_auth_code' do
      # 生成 offline_recharge时 需要验证金额 、验证code
      parameter :amount, '申请充值的金额', scope: :offline_recharge

      let(:amount) { 100 }
      
      example "工作人员 申请获取 授权码（指定金额）” 成功" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end

    post 'worker/offline_recharges' do

      parameter :user_id, "用户id", required: true, scope: :offline_recharge
      parameter :amount, "充值金额", required: true, scope: :offline_recharge
      parameter :credit, "赠送积分", required: true, scope: :offline_recharge
      parameter :auth_code, '充值授权码', require: true, scope: :offline_recharge
      let(:user_id) { @user.id }
      let(:amount) { 2000 }
      let(:credit) { 200 }
      let(:auth_code) { '1234' }

      describe 'success' do
        before do
          SmsToken.create(auth_key: "worker-#{@worker.phone}-2000", token: '1234')
        end
        example "工作人员 创建线下充值成功" do
          do_request
          puts response_body
          expect(status).to eq(201)
        end
      end

      describe 'fail' do
        example "工作人员 创建线下充值 失败（未获取授权码、授权金额错误）" do
          do_request
          puts response_body
          expect(status).to eq(422)
        end

        describe '验证码失效' do
          before do
            SmsToken.create(
              auth_key: "worker-#{@worker.phone}-2000", token: '1234',
              updated_at: Time.zone.yesterday
            )
          end
          example "工作人员 创建线下充值失败（授权码已过期" do
            do_request
            puts response_body
            expect(status).to eq(422)
          end
        end

        describe '验证码 错误' do
          before do
            SmsToken.create(
              auth_key: "worker-#{@worker.phone}-2000", token: 'hahaha'
            )
          end
          example "工作人员 创建线下充值失败（授权码填写错误" do
            do_request
            puts response_body
            expect(status).to eq(422)
          end
        end

      end
      
    end

    get 'worker/offline_recharges/:id' do

      let(:id) {@offline_recharges.first.id}

      example "工作人员查询某价目详细信息成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

  end
end
