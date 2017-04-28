require 'acceptance_helper'

resource "配送 相关" do
  header "Accept", "application/json"
  describe 'About User' do 
    before do
      @user = create(:user)
      header "X-User-Phone", @user.phone
      header "X-User-Token", @user.authentication_token

      @user_info = create(:user_info, user: @user,
                                      default_address_id: 0 
                          )
      create_list(:address, 2, user_info: @user_info)
      create_list(:vip_level, 4)
      create_list(:store_method, 3)
      @stocking_chest = create(:stocking_chest)
      @chest = create(:exhibition_chest, exhibition_unit:  @stocking_chest.exhibition_units.first)
      @stored_garments = create_list(:garment, 2, user: @user, status: 'stored', exhibition_chest: @chest)
      @garments_in_basket = create_list(:garment, 3 , user: @user, status: 'in_basket', exhibition_chest: @chest)
    end

    describe ' About Basket' do 
      get '/garments/basket' do 
        example "用户 查看配送篮中衣服" do
          do_request
          puts response_body
          expect(status).to eq(200)
        end
      end

      post '/garments/add_them_to_basket' do

        parameter :garment_ids, "衣服id 数组", required: true

        let(:garment_ids) { @stored_garments.collect(&:id) }

        example "【用户】加入衣服至【配送篮】成功" do
          do_request
          puts response_body
          expect(status).to eq(201)
        end

        describe '失败' do 
          let(:garment_ids) { [ @garments_in_basket.collect(&:id)] }
          example "【用户】加入衣服至【配送篮】失败， 衣服起始状态错误(不对错误id报错）" do
            do_request
            puts response_body
            expect(status).to eq(422)
          end
        end
      end

      post '/garments/get_out_of_basket' do

        parameter :garment_ids, "衣服id 数组", required: true

        let(:garment_ids) { [@garments_in_basket.first.id]}

        example "【用户】 将衣服移出 配送篮 成功" do
          do_request
          puts response_body
          expect(status).to eq(201)
        end

        describe '失败' do 
          let(:garment_ids) { @stored_garments.collect(&:id) }
          example "【用户】移出 配送篮， 衣服起始状态错误" do
            do_request
            puts response_body
            expect(status).to eq(422)
          end
        end
      end
    end

    describe 'About Delivery Order' do 

      before do 
        @delivery_order1 = create(:delivery_order, user: @user, 
          garment_ids: @garments_in_basket.collect(&:id)
          )
        @delivery_order2 = create(:delivery_order, user: @user, 
          garment_ids: @garments_in_basket.collect(&:id) + @stored_garments.collect(&:id)
          )
        @delivery_order3 = create(:delivery_order, user: @user, 
          garment_ids: @stored_garments.collect(&:id)
          )
      end

      get '/delivery_orders' do 
        parameter :page, "当前页", require: false
        parameter :per_page, "每页的数量", require: false
        parameter :need_garment_info, '是否需要衣服信息', required: false

        parameter :state, '查询状态，默认返回全部， 
          可使用值：unpaid 未支付, paid 已支付, delivering 已发出, finished 已完成'

        let(:page) { 2 }
        let(:per_page) { 2 }
        let(:need_garment_info) { false }

        example "【用户】获取配送订单列表成功（所有状态）" do
          do_request
          puts response_body
          expect(status).to eq(200)
          expect(response_body['delivery_orders']['garments']).to eq(nil)
        end

        describe '可查询' do
          before do
            @delivery_order1.pay!
          end
          let(:page) { 1 }
          let(:per_page) { 2 }
          let(:state) { 'paid' }
          let(:need_garment_info) { true }

          example "【用户】查询 某状态 配送订单列表成功" do
            do_request
            puts response_body
            expect(status).to eq(200)
            expect(JSON.parse(response_body)['delivery_orders'].first['garments']).to be_truthy
          end
        end
      end

      get '/delivery_orders/:id' do 
        let(:id) { @delivery_order2.id }
        example "【用户】查询 某配送订单详情成功" do
          do_request
          puts response_body
          expect(status).to eq(200)
        end
      end

      post 'delivery_orders' do
        parameter :address, '收货人 地址', required: true, scope: :delivery_order
        parameter :name, '收货人 姓名', required: true, scope: :delivery_order
        parameter :phone, '收货人 电话', required: true, scope: :delivery_order
        parameter :delivery_time, '收件时间', required: true, scope: :delivery_order
        parameter :delivery_method, '配送方式', required: true, scope: :delivery_order
        parameter :remark, '备注，无内容请传空字符串', required: true, scope: :delivery_order
        parameter :delivery_cost, '配送费用', required: true, scope: :delivery_order
        parameter :service_cost, '服务费用', required: true, scope: :delivery_order
        parameter :garment_ids, '所含衣服 id 数组 Array', required: true, scope: :delivery_order, type: :array

        let(:address) { '我是地址' }
        let(:name) { '我是收件人姓名' }
        let(:phone) { '我是收件人电话' }
        let(:delivery_time) { '2012-12-21' }
        let(:delivery_method) { '快递配送' }
        let(:remark) { '我是 备注 备注 备注 ...' }
        let(:delivery_cost) { 1000 }
        let(:service_cost) { 100 }
        let(:garment_ids) { @stored_garments.collect(&:id) }

        describe '成功' do
          example '【用户】选择衣服后 创建 配送订单 成功 ' do
            do_request
            puts response_body
            expect(status).to eq(201)
          end
        end

        describe '失败' do
          let(:garment_ids) { '' }
          example '【用户】选择衣服后 创建 配送订单 失败（garment_ids必须为array）' do          
            do_request
            puts response_body
            expect(status).to eq(422)
          end
        end
      end

      put 'delivery_orders/:id' do
        parameter :address, '收货人 地址', required: true, scope: :delivery_order
        parameter :name, '收货人 姓名', required: true, scope: :delivery_order
        parameter :phone, '收货人 电话', required: true, scope: :delivery_order
        parameter :delivery_time, '收件时间', required: true, scope: :delivery_order
        parameter :delivery_method, '配送方式', required: true, scope: :delivery_order
        parameter :remark, '备注，无内容请传空字符串', required: true, scope: :delivery_order
        parameter :delivery_cost, '配送费用', required: true, scope: :delivery_order
        parameter :service_cost, '服务费用', required: true, scope: :delivery_order
        parameter :garment_ids, '所含衣服 id 数组 Array', required: true, scope: :delivery_order

        let(:address) { '我是地址' }
        let(:name) { '我是收件人姓名' }
        let(:phone) { '我是收件人电话' }
        let(:delivery_time) { '2012-12-21' }
        let(:delivery_method) { '快递配送' }
        let(:remark) { '我是 备注 备注 备注 ...' }
        let(:delivery_cost) { 1000 }
        let(:service_cost) { 100 }
        let(:garment_ids) { @stored_garments.collect(&:id) }

        let(:id) { @delivery_order1.id }
         
        example '【用户】修改 配送订单 成功 ' do
          do_request
          puts response_body
          expect(status).to eq(201)
        end

        describe '失败' do
          before do
            @delivery_order2.pay!
          end
          let(:id) { @delivery_order2.id }
          example '【用户】选择衣服后 创建 配送订单 失败（不可修改已支付订单）' do          
            do_request
            puts response_body
            expect(status).to eq(422)
          end
        end
      end

      delete 'delivery_orders/:id' do
        let(:id) { @delivery_order2.id }
        example '删除 配送订单 成功 ' do
          do_request
          puts response_body
          expect(status).to eq(204)
        end
      end

      post 'delivery_orders/:id/pay' do
        let(:id) { @delivery_order2.id }
        example '【用户】支付 配送订单 成功 ' do
          expect(PurchaseLog.all.count).to eq(0)
          balance = @user.info.balance
          do_request
          puts response_body
          expect(status).to eq(201)
          expect(PurchaseLog.all.count).to eq(1)
          purchase_log = PurchaseLog.first
          p purchase_log
          expect(purchase_log.amount).to eq(@delivery_order2.amount)
          expect(purchase_log.user_info.balance).to eq( balance - @delivery_order2.amount)
        end
        
        describe '失败' do
          before do
          # 支付 order 1  将会导致 order 2 部分衣服已支付
           @delivery_order1.pay!
          end
          let(:id) { @delivery_order2.id }
          example '【用户】支付 配送订单 失败（所选部分衣服已在配送中） ' do
            do_request
            puts response_body
            expect(status).to eq(422)
          end
        end

      end

      post 'delivery_orders/:id/get_home' do
        before do
        # 支付 order 1  将会导致 order 2 部分衣服已支付
          @delivery_order1.pay!
          @delivery_order1.admin_send_it_out!
        end
        let(:id) { @delivery_order1.id }
        example '【用户】签收完成 配送订单 成功 ' do
          do_request
          puts response_body
          expect(status).to eq(201)
        end

        describe '失败' do
          let(:id) { @delivery_order2.id }
          example '【用户】签收完成 配送订单 失败（目标订单状态错误' do
            do_request
            puts response_body
            expect(status).to eq(422)
          end
        end
      end

    end
  end


  describe 'About Admin' do
    before do
      @user = create(:user)
      @admin = create(:admin)
      header "X-Admin-Email", @admin.email
      header "X-Admin-Token", @admin.authentication_token

      @user_info = create(:user_info, user: @user,
                                      default_address_id: 0 
                          )
      create_list(:address, 2, user_info: @user_info)
      create_list(:vip_level, 4)
      create_list(:store_method, 3)
      @stocking_chest = create(:stocking_chest)
      @chest = create(:exhibition_chest, exhibition_unit:  @stocking_chest.exhibition_units.first)
      @stored_garments = create_list(:garment, 2, user: @user, status: 'stored', exhibition_chest: @chest)
      @garments_in_basket = create_list(:garment, 3 , user: @user, status: 'in_basket', exhibition_chest: @chest)
      @delivery_order1 = create(:delivery_order, user: @user, 
          garment_ids: @garments_in_basket.collect(&:id)
          )
      @delivery_order2 = create(:delivery_order, user: @user, 
        garment_ids: @garments_in_basket.collect(&:id) + @stored_garments.collect(&:id)
        )
      @delivery_order3 = create(:delivery_order, user: @user, 
        garment_ids: @stored_garments.collect(&:id)
        )
    end

    get '/admin/delivery_orders' do 
      parameter :page, "当前页", require: false
      parameter :per_page, "每页的数量", require: false
      parameter :need_garment_info, '是否需要衣服信息', required: false

      parameter :state, '查询状态，默认返回全部， 
        paid 已支付, delivering 已发出, finished 已完成'

      let(:page) { 2 }
      let(:per_page) { 2 }
      let(:need_garment_info) { false }

      example "【管理员】查询 某状态 配送订单列表成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    get '/admin/delivery_orders/:id' do 
      let(:id) { @delivery_order2.id }
      example "【管理员】查询 某配送订单详情成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    post 'admin/delivery_orders/:id/cancel' do
      before do
      # 支付 order 1  将会导致 order 2 部分衣服已支付
        @delivery_order1.pay!
      end

      let(:id) { @delivery_order1.id }

      example '【管理员】取消某已支付配送订单 成功（衣服返回用户柜子，并退款） ' do
        order = @delivery_order1
        user_info = @delivery_order1.user.info
        balance = user_info.balance
        do_request
        puts response_body
        
        expect(status).to eq(201)
        expect(DeliveryOrder.find(order.id).user.info.balance).to eq(balance + order.amount)
        expect(order.its_garments.collect(&:status).uniq).to eq(['stored'])
      end

      describe '失败' do
        let(:id) { @delivery_order2.id }
        example '【管理员】取消某配送订单失败 ' do
          do_request
          puts response_body
          expect(status).to eq(422)
        end
      end
    end

      post 'admin/delivery_orders/:id/send_out' do
        before do
        # 支付 order 1  将会导致 order 2 部分衣服已支付
          @delivery_order1.pay!
        end
        let(:id) { @delivery_order1.id }
        example '【管理员】某配送订单 发货 成功 ' do
          do_request
          puts response_body
          expect(status).to eq(201)
        end

        describe '失败' do
          let(:id) { @delivery_order2.id }
          example '【管理员】为 某配送订单 发货 失败（目标订单状态错误） ' do
            do_request
            puts response_body
            expect(status).to eq(422)
          end
        end
      end

  end


end