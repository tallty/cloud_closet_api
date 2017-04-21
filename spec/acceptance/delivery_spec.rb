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
        @delivery_order2 = create(:delivery_order, user: @user, 
          garment_ids: @stored_garments.collect(&:id)
          )
      end

      get '/delivery_orders' do 
        parameter :page, "当前页", require: false
        parameter :per_page, "每页的数量", require: false
        parameter :state, '查询状态，默认返回全部， 
          可使用值：unpaid 未支付, paid 已支付, delivering 已发出, finished 已完成'

        let(:page) { 2 }
        let(:per_page) { 2 }

        example "【用户】获取配送订单列表成功（所有状态）" do
          # p @delivery_order2
          do_request
          puts response_body
          expect(status).to eq(200)
        end

        describe '可查询' do
          let(:state) { 'paid' }
          example "【用户】查询 某状态 配送订单列表成功" do
            do_request
            puts response_body
            expect(status).to eq(200)
          end
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

      # post 'delivery_order/:id/pay' do

      #   example '【用户】支付 配送订单 成功 ' do
      #     do_request
      #     puts response_body
      #     expect(status).to eq(201)
      #   end
      
      # end

      # post 'delivery_order/:id/sign_for_delivery'

    end
  end

end