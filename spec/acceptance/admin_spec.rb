require 'acceptance_helper'
require 'rails_helper'
resource "管理后台相关接口" do
  header "Accept", "application/json"

  before do 
    @sent = 0
    allow_any_instance_of(WechatMessageService).to receive(:send_msg) {
      @sent += 1
    }
    create_list(:store_method, 3)
    create_list(:garment_tag, 3)
    create_list(:vip_level, 4)
    # 创建价格表
    @stocking_chest = create(:stocking_chest) 
    @group_chest1 = create(:group_chest1)
    @alone_full_dress_chest = create(:alone_full_dress_chest)
    @vacuum_bag_medium = create(:vacuum_bag_medium)

    @user = create(:user)
    @worker = create(:worker)
    @user_info = create(:user_info, user: @user)
    @admin = create(:admin)
    price_system_ary = [@stocking_chest, @group_chest1, @alone_full_dress_chest, @vacuum_bag_medium]
    @appointments = create_list(
        :appointment, 4,
        user: @user, 
        garment_count_info: {
          hanging: 15,
          full_dress: 5 
        }
        )
    price_system_ary.each do |price_system|
      create(:appointment_price_group, 
          appointment: @appointments.first,
          price_system: price_system,
          store_month: 2
          )
    end
    @appointments.first.accept!
    @appointments.first.service!
    @appointments.first.pay!
    @appointments.first.storing!

    @appointments.second.accept!
    @appointments.second.service!
    @appointments.second.pay!
    @appointments.second.storing!
    @appointments.second.stored! #??

    @exhibition_chests = @user.exhibition_chests
    # 创建用户原有衣柜
    @valuation_chest = create(:valuation_chest,
      price_system: @stocking_chest,
      user: @user,
      appointment_price_group: AppointmentPriceGroup.first
    )
    @exhibition_chest1 = create(:exhibition_chest, 
      exhibition_unit: @stocking_chest.exhibition_units.first,
      custom_title: 'aaaaaaaaaaaaaa',
      valuation_chest: @valuation_chest,
      user: @user,
      expire_time: Time.zone.now + 2.month
      )
    @garments = create_list(
      :garment, 3,
      exhibition_chest: @exhibition_chests.first,
      ) 
    @price_systems = PriceSystem.all

    header "X-Admin-Token", @admin.authentication_token
    header "X-Admin-Email", @admin.email

  end


  describe 'admin authentication' do

    before do
      header "X-Admin-Token", nil
      header "X-Admin-Email", nil
    end

    post "/admins/sign_in" do

      parameter :email, "登录的邮箱", required: true, scope: :admin
      parameter :password, "登录密码", required: true, scope: :admin

      admin_attrs = FactoryGirl.attributes_for :admin
      let(:email) { admin_attrs[:email] }
      let(:password) { admin_attrs[:password] }

      response_field :id, "用户ID"
      response_field :email, "邮箱"
      response_field :created_at, "创建时间"
      response_field :updated_at, "更新时间"
      response_field :authentication_token, "鉴权Token"

      example "管理员登录成功" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end
  end


  describe 'appointment condition is all correct' do

    get 'admin/appointments' do

      parameter :page, "当前页", require: false
      parameter :per_page, "每页的数量", require: false

      parameter :query_state, "输入查询的状态(storing: 入库中，stored: 已上架)", require: false
      parameter :user_id, '新增用户id查询，条件可同时存在', required: false
      parameter :created_by_admin, '是否由管理员创建'

      let(:query_state) {"stored"}

      example "【new】【新增用户id查询】管理员查询所有‘已上架'或者‘入库中‘的预订订单的列表成功" do
        do_request
        puts response_body
        expect(status).to eq 200
      end

      describe 'get appt :created by admin' do
        let(:query_state) {"stored"}
        let(:created_by_admin) { true }
        example "【new】【新增created_by_admin 查询】管理员查询所有‘已上架'或者‘入库中‘的预订订单的列表成功" do
          do_request
          puts response_body
          expect(JSON.parse(response_body)['appointments'].blank?).to eql(true)
          expect(status).to eq 200
        end
      end
    end

    get 'admin/appointments/:id' do
      let(:id) { @appointments.first.id }

      example "管理员查看指定的预订订单详情成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    post 'admin/users/:user_id/appointments' do
      
      parameter :user_id, '用户id', required: true
      parameter :remark, '备注', required: false, scope: :appointment
      parameter :care_type, '护理类型', required: true, scope: :appointment
      parameter :care_cost, '护理费用', required: true, scope: :appointment        
      parameter :service_cost, '服务费', required: true, scope: :appointment

      parameter :count, "price_group 此栏选择的衣柜/真空袋数量", required: false, scope: [ :appointment_groups, :price_groups ]
      parameter :price_system_id, '价格 price_system id', required: false, scope: [ :appointment_groups, :price_groups ]
      parameter :store_month, "存放的月份数", required: false, scope: [ :appointment_groups, :price_groups ]

      example "【new】管理员  创建普通预约订单（新建柜子，或 收取服务费），需要用户确认收费" do
        sent_was = @sent
        params = {
          user_id: @user.id,
          appointment:
            {
              remark: '我是备注',
              care_cost: 100,
              service_cost: 200,
            },
          appointment_groups: 
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
        expect(@sent - sent_was).to eq 1
        puts response_body
        expect(status).to eq(201)
      end

      describe '只填写柜子' do
        example "【new】管理员  创建服务订单（不填写柜子 " do
          params = {
            user_id: @user.id,
            appointment_groups: 
            {
              price_groups: [
                {
                  price_system_id: @stocking_chest.id,
                  count: 1,
                  store_month: 3,
                },
              ]
            }
          }

          do_request params
          puts response_body
          expect(status).to eq(201)
        end
      end

      describe '不填写柜子' do
        example "【new】管理员  创建服务订单  只填写柜子 " do
          params = {
            user_id: @user.id,
            appointment:
              {
                remark: '我是备注',
                care_cost: 100,
                service_cost: 200,
              }
          }

          do_request params
          puts response_body
          expect(status).to eq(201)
        end
      end
      describe '禁止创建空订单' do
        example "【new】管理员  创建服务订单 失败 禁止创建空订单 " do
          params = {
            user_id: @user.id,
          }

          do_request params
          puts response_body
          expect(status).to eq(422)
        end
      end
    end

    # get 'admin/appointments/:id/its_chests' do
    # 	let(:id) { @appointments.first.id }
    #   example "管理员获取指定的订单下面的所有 该用户可操作衣柜 成功" do
    #     do_request
    #     puts response_body
    #     expect(status).to eq(200)
    #   end
    # end

     put 'admin/appointments/:id' do
      parameter :garment_count_info, 
        '各类衣服件数， 必须传入所有 类型的数量。 garment_count_info: {hanging: 10, stacking: 100, full_dress: 100}',
        require: true, scope: :appointment
      
      let(:id) { @appointments.first.id }


      example "【new】管理员 修改订单  存衣数量 成功" do
        params = {
          appointment:{
            garment_count_info: {
              hanging: 999,
              stacking: 999,
              full_dress: 999
            }
          }
        }
        do_request params
        puts response_body
        expect(JSON.parse(response_body)['garment_count_info']).to eq(
          { 'hanging'=> 999, 'stacking'=> 999, 'full_dress' => 999 }
        )
        expect(status).to eq(200)
      end
    end

    put 'admin/exhibition_chests/:id' do
      parameter :max_count, scope: :exhibition_chest

      let(:id) { @exhibition_chest1.id }
      let(:max_count) { 99 }
      example "【new】管理员 修改衣柜 存衣上限 成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end

      describe '单礼服柜 不能修改上限' do
        let(:id) { ExhibitionChest.all.select{ |chest| chest.need_join }.first.id }
        let(:max_count) { 99 }

        example "【new】管理员 修改衣柜 存衣上限 失败（ 单礼服柜 不能修改上限）" do
          do_request
          puts response_body
          expect(status).to eq(422)
        end
      end
    end

    post 'admin/exhibition_chests/:id/garments' do
      image_attrs = FactoryGirl.attributes_for(:image, photo_type: "avatar")
      garment_attrs = FactoryGirl.attributes_for(:garment)

      parameter :appointment_id, "当前订单id", required: true
      # 文字描述
      parameter :title, "衣服标题", require: false, scope: :garment
      parameter :description, "衣服描述信息", require: false, scope: :garment
      # 标签
      parameter :add_tag_list, "【添加的】标签 组成的字符串，以英文逗号',' 分隔各标签", required: true, scope: :garment
      # 存放位置
      parameter :row, "衣服存放的 排 ", require: false, scope: :garment
      parameter :carbit, "衣服存放的 柜 ", require: false, scope: :garment
      parameter :place, "衣服存放的 位 ", require: false, scope: :garment
      # 图片
      parameter :cover_image_attributes, "衣服的封面图", require: false, scope: :garment
      parameter :detail_image_1_attributes, "衣服的详细图片1", require: false, scope: :garment
      parameter :detail_image_2_attributes, "衣服的详细图片2", require: false, scope: :garment
      parameter :detail_image_3_attributes, "衣服的详细图片3", require: false, scope: :garment

      let(:id) { @exhibition_chests.first.id }

      let(:store_month) { 12 }
      let(:title) { "garemnt title" }
      let(:description) { '我是简述简述简述' }
      let(:add_tag_list) { '上衣' }
      let(:row) { 1 }
      let(:carbit) { 3 }
      let(:place) { 2 }
      let(:cover_image_attributes) { image_attrs }
      let(:detail_image_1_attributes) { image_attrs }
      let(:detail_image_2_attributes) { image_attrs }
      let(:detail_image_3_attributes) { image_attrs }

      example "管理员创建 对应衣柜中的衣服的详细信息成功" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end

    put 'admin/exhibition_chests/:exhibition_chest_id/garments/:id' do
      image_attrs = FactoryGirl.attributes_for(:image, photo_type: "avatar")

      # parameter :appointment_id, "当前订单id", required: true
      # 文字描述
      parameter :title, "衣服标题", require: false, scope: :garment
      parameter :description, "衣服描述信息", require: false, scope: :garment
      parameter :status, "衣服状态,  storing: '入库中'
        caring: '护理中'
        stored: '已入库'
        in_basket: '配送篮中'
        delivering: '配送中'
        at_home: '已到达'", required: false, scope: :garment
      # 标签
      parameter :add_tag_list, "【添加的】标签 组成的字符串，以英文逗号',' 分隔各标签", required: true, scope: :garment
      parameter :remove_tag_list, "【删除的】标签 组成的字符串，以英文逗号',' 分隔各标签", required: true, scope: :garment
      # 存储位置
      parameter :row, "衣服存放的 排 ", require: false, scope: :garment
      parameter :carbit, "衣服存放的 柜 ", require: false, scope: :garment
      parameter :place, "衣服存放的 位 ", require: false, scope: :garment
      # 图片
      parameter :cover_image_attributes, "衣服的封面图", require: false, scope: :garment
      parameter :detail_image_1_attributes, "衣服的详细图片1", require: false, scope: :garment
      parameter :detail_image_2_attributes, "衣服的详细图片2", require: false, scope: :garment
      parameter :detail_image_3_attributes, "衣服的详细图片3", require: false, scope: :garment

      let(:exhibition_chest_id) { @exhibition_chests.first.id }
      # let(:appointment_id) { @appointments.first.id }
      let(:id) { @exhibition_chests.first.garments.first.id }
      let(:title) { "garemnt new title" }
      let(:status) { 'caring' }
      let(:description) { '我是新简述 新简述新简述' }
      let(:add_tag_list) { '上衣,半裙' }
      let(:remove_tag_list) { '上衣' }
      let(:row) { 1 }
      let(:carbit) { 3 }
      let(:place) { 2 }
      let(:cover_image_attributes) { image_attrs }
      let(:detail_image_1_attributes) { image_attrs }
      let(:detail_image_2_attributes) { image_attrs }
      let(:detail_image_3_attributes) { image_attrs }

      example "管理员修改 对应衣柜中的衣服的详细信息成功" do
        do_request
        puts response_body
        expect(response_status).to eq(201)
      end
      
      describe '只改变状态' do
        let(:id) { @exhibition_chests.first.garments.first.id }
        let(:status) { 'delivering' }
        example "【new】管理员修改 衣服状态" do
          do_request
          puts response_body
          expect(response_status).to eq(201)
        end
      end
      

      describe '状态非法' do
        let(:id) { @exhibition_chests.first.garments.first.id }
        let(:status) { 'hahaha' }

        example "【new】管理员修改 衣服状态失败（状态非法" do
          do_request
          puts response_body
          expect(response_status).to eq(422)
        end
      end
    end

    get 'admin/users/:id/exhibition_chests' do
      let(:id) { @user.id }
      example "【new】管理员查看 某用户的所有衣柜【库存管理】" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    post 'admin/exhibition_chests/:id/lease_renewal' do
      parameter :renewal_month, required: true
      before do
        @expire_time_was = @exhibition_chests.first.expire_time
      end
      let(:id) { @exhibition_chests.first.id }
      let(:renewal_month) { 1 }
      example "【new】【new】【new】管理员 对某衣橱 续柜 成功" do
        do_request
        # 柜子租期不变
        expect(@exhibition_chests.first.expire_time).to eq(@expire_time_was)
        # 生成待支付的 续期订单 appointment
        @lease_renewal_appt = @user.appointments.last
        expect(@lease_renewal_appt.meta[:lease_renewal_chest_id]).to eq(@exhibition_chests.first.id)
        
        puts response_body
        expect(status).to eq(201)

        @lease_renewal_appt.pay!
        expect(@exhibition_chests.first.expire_time).to eq(@expire_time_was + 1.month)
        # expect()
      end

      describe '【new】管理员 对某衣柜 续柜 成功（组合柜将同时续柜）' do
        
        before do
          @group_exh_chest1, @group_exh_chest2 = ValuationChest.where(price_system: @group_chest1).first.exhibition_chests.to_a
          @expire_time_was1 = @group_exh_chest1.expire_time
        end

        let(:id) { @group_exh_chest1.id }
        let(:renewal_month) { 1 }

        example "【new】管理员 对某衣橱 续柜 成功" do
          do_request
          @user.appointments.last.pay!
          # 组合柜 一起延期
          expect(@group_exh_chest1.expire_time.strftime("%Y-%m-%d %H:%M")).to eq(@group_exh_chest2.expire_time.strftime("%Y-%m-%d %H:%M"))
          expect(ExhibitionChest.find(@group_exh_chest1.id).expire_time).to eq(@expire_time_was1 + 1.month)
          # 生成 purchase_log 成功
          expect(PurchaseLog.last.amount).to eq(ValuationChest.where(price_system: @group_chest1).first.price * 1)
          
          puts response_body
          expect(status).to eq(201)
        end
      end
    end

    get 'admin/exhibition_chests/:id/garments' do
      let(:id) { @exhibition_chests.first.id }

      example "管理员查看 某衣柜的所有衣服 成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    get 'admin/exhibition_chests/:id/garments/:id' do
      let(:exhibition_chest_id) { @exhibition_chests.first }
      let(:id) { @exhibition_chests.first.garments.first.id }

      example "管理员查看某衣柜中 某一衣服 成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    get 'admin/garments/:id' do
      let(:id) { @exhibition_chests.first.garments.first.id }

      example "管理员查看衣服的详细信息成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end


    delete 'admin/garments/:id' do
      let(:id) { @exhibition_chests.first.garments.first.id }

      example "管理员删除 衣服 成功" do
        do_request
        puts response_body
        expect(status).to eq(204)
      end
    end


    post '/admin/appointments/:id/stored' do
      let(:id) { @appointments.first.id }

      example "管理员‘确认上架’指定预订订单成功" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end

    post '/admin/appointments/:id/cancel' do
      before do
        @appointments.first.update!(aasm_state: 'unpaid')
      end
      let(:id) { @appointments.first.id }

      example "管理员‘取消’指定预订订单成功（合法起始状态：committed, accepted, unpaid" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end

    post '/admin/appointments/:id/cancel' do
      before do
        @appointments.first.update!(aasm_state: 'unpaid')
      end
      let(:id) { @appointments.first.id }

      example "管理员‘取消’指定预订订单成功（合法起始状态：committed, accepted, unpaid" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end

    post '/admin/appointments/:id/recover' do
      before do
        @appointments.first.update!(aasm_state: 'canceled')
      end
      let(:id) { @appointments.first.id }

      example "管理员 恢复 已取消订单至未支付成功" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end

    delete '/admin/appointments/:id' do
      before do
        @appointments.first.update!(aasm_state: 'canceled')
      end
      let(:id) { @appointments.first.id }

      example "管理员 删除历史订单（已取消订单 成功" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end

    # post 'admin/exhibition_chests/:id/release' do 
    #   let(:id) { @exhibition_chests.first.id }
    # 	example "管理员‘发布某衣柜’成功，可多次发布" do
    #     do_request
    #     puts response_body
    #     expect(status).to eq(201)
    #   end
  	# end

  end

  # describe '服务订单 ServiceOrder' do
    
  #   before do
  #     create_list(:service_order, 3, user: @user)
  #   end

  #   get 'admin/users/:user_id/service_orders' do
  #     let(:user_id) { @user.id }
  #     example "【new】管理员 查看某用户所有服务订单 列表 成功" do
  #       do_request
  #       puts response_body
  #       expect(status).to eq(200)
  #     end
      
  #     describe '用户不存在' do
  #       let(:user_id) { 0 }
  #       example "【new】管理员 查看某用户所有服务订单 列表 失败 （用户不存在）" do
  #         do_request
  #         puts response_body
  #         expect(status).to eq(404)
  #       end
  #     end
  #   end

  #   get 'admin/service_orders' do
  #     example "【new】管理员 查看 所有用户 所有服务订单 列表 成功" do
  #       do_request
  #       puts response_body
  #       expect(status).to eq(200)
  #     end
  #   end

  #   get 'admin/service_orders' do
  #     example "【new】管理员 查看 所有用户 所有服务订单 列表 成功" do
  #       do_request
  #       puts response_body
  #       expect(status).to eq(200)
  #     end
  #   end

  #   post 'admin/users/:user_id/service_orders' do
      
  #     parameter :user_id, '用户id', required: true
  #     parameter :remark, '备注', required: false, scope: :service_order
  #     parameter :care_cost, '护理费用', required: true, scope: :service_order        
  #     parameter :service_cost, '服务费', required: true, scope: :service_order

  #     parameter :count, "price_group 此栏选择的衣柜/真空袋数量", required: true, scope: [ :service_order_groups, :price_groups ]
  #     parameter :price_system_id, '价格 price_system id', required: true, scope: [ :service_order_groups, :price_groups ]
  #     parameter :store_month, "存放的月份数", required: false, scope: [ :service_order_groups, :price_groups ]

  #     example "【new】管理员  创建服务订单（新建柜子，或 收取服务费）注：创建后立刻收取费用（是否需要一个“收费”操作的接口" do
  #       params = {
  #         user_id: @user.id,
  #         service_order:
  #           {
  #             remark: '我是备注',
  #             care_cost: 100,
  #             service_cost: 200,
  #           },
  #         service_order_groups: 
  #           {
  #             price_groups: [
  #               {
  #                 price_system_id: @stocking_chest.id,
  #                 count: 1,
  #                 store_month: 3,
  #               },
  #               {
  #                 price_system_id: @group_chest1.id,
  #                 count: 2,
  #                 store_month: 4,
  #               },
  #               {
  #                 price_system_id: @vacuum_bag_medium.id,
  #                 count: 2,
  #                 store_month: 2,
  #               },
  #               {
  #                 price_system_id: @alone_full_dress_chest.id,
  #                 count: 4,
  #                 store_month: 6,
  #               },
  #             ]
  #           }
  #       }

  #       do_request params
  #       expect(PurchaseLog.last.amount).to eq(5500)
  #       puts response_body
  #       expect(status).to eq(201)
  #     end

  #     describe '只填写柜子' do
  #       example "【new】管理员  创建服务订单（不填写柜子 " do
  #         params = {
  #           user_id: @user.id,
  #           service_order_groups: 
  #           {
  #             price_groups: [
  #               {
  #                 price_system_id: @stocking_chest.id,
  #                 count: 1,
  #                 store_month: 3,
  #               },
  #             ]
  #           }
  #         }

  #         do_request params
  #         puts response_body
  #         expect(status).to eq(201)
  #       end
  #     end

  #     describe '不填写柜子' do
  #       example "【new】管理员  创建服务订单  只填写柜子 " do
  #         params = {
  #           user_id: @user.id,
  #           service_order:
  #             {
  #               remark: '我是备注',
  #               care_cost: 100,
  #               service_cost: 200,
  #             }
  #         }

  #         do_request params
  #         puts response_body
  #         expect(status).to eq(201)
  #       end
  #     end
  #     describe '禁止创建空订单' do
  #       example "【new】管理员  创建服务订单 失败 禁止创建空订单 " do
  #         params = {
  #           user_id: @user.id,
  #         }

  #         do_request params
  #         puts response_body
  #         expect(status).to eq(422)
  #       end
  #     end

  #     describe '余额不足' do
  #       before do
  #         @user_info.balance = 0
  #         @user_info.save
  #       end
  #       example "【new】管理员  创建服务订单 失败（余额不足" do
  #         params = {
  #           user_id: @user.id,
  #           service_order:
  #             {
  #               remark: '我是备注',
  #               care_cost: 100,
  #               service_cost: 200,
  #             },
  #           service_order_groups: 
  #             {
  #               price_groups: [
  #                 {
  #                   price_system_id: @stocking_chest.id,
  #                   count: 1,
  #                   store_month: 3,
  #                 },
  #               ]
  #             }
  #         }

  #         do_request params
  #         puts response_body
  #         expect(status).to eq(422)
  #       end
  #     end
  #   end
  # end

  

  # describe '价格系统操作' do
  
  #   get 'admin/price_systems' do

  #     parameter :page, "当前页", required: false
  #     parameter :per_page, "每页的数量", required: false

  #     let(:page) {2}
  #     let(:per_page) {2}

  #     example "管理员查询价目列表成功" do
  #       do_request
  #       puts response_body
  #       expect(status).to eq(200)
  #     end
  #   end

  #   get 'admin/price_systems/:id' do

  #     let(:id) {@price_systems.first.id}

  #     example "管理员查询某价目详细信息成功" do
  #       do_request
  #       puts response_body
  #       expect(status).to eq(200)
  #     end
  #   end

  #   post 'admin/price_systems' do
      
  #     price_system_attrs = FactoryGirl.attributes_for(:stocking_chest)
  #     let(:id) {@price_systems.first.id}

  #     parameter :title, "衣服类型名称", required: true, scope: :price_system
  #     parameter :price, "单价", required: true, scope: :price_system
  #     parameter :is_chest, "是否为衣柜", required: true, scope: :price_system
  #     parameter :unit_name, '单位名称', required: true, scope: :price_system
  #     parameter :description, "简介", required: false, scope: :price_system
  #     parameter :price_icon_image, "封面图", require: true, scope: :price_system

  #     let(:title) { 'new_title' }
  #     let(:price) { 999 }
  #     let(:is_chest) { true }
  #     let(:unit_name) { '月' }
  #     let(:description) { '我是简介简介简介简介' }
  #     let(:price_icon_image) { price_system_attrs[:price_icon_image] }

  #     example "管理员创建价目信息成功" do
  #       do_request
  #       puts response_body
  #       expect(status).to eq(201)
  #     end
  #   end

    # describe '线下充值' do

    #   before do 
    #     SmsToken.create(auth_key: "worker-#{@worker.phone}-1000", token: '1111')
    #     @offline_recharges = create_list(
    #         :offline_recharge, 3,
    #         user: @user,
    #         worker: @worker,
    #         auth_code: '1111'
    #       )
          
    #   end

    #   post 'admin/offline_recharges/:id/to_confirmed_or_not' do
        
    #     let(:id) {@offline_recharges.first.id}

    #     example "管理员 确认/取消确认 线下充值单据" do
    #       do_request
    #       puts response_body
    #       expect(status).to eq(201)
    #     end
    #   end

    #   get 'admin/offline_recharges' do
    #     example "管理员 查询 线下充值单据 列表成功" do
    #       do_request
    #       puts response_body
    #       expect(status).to eq(200)
    #     end
    #   end

    #   get 'admin/offline_recharges/:id' do

    #     let(:id) {@offline_recharges.first.id}

    #     example "管理员 查询 某线下充值单据 详情成功" do
    #       do_request
    #       puts response_body
    #       expect(status).to eq(200)
    #     end
    #   end
    # end

  describe '用户 与 衣柜 列表' do
    get 'admin/users' do
      parameter :page, "当前页", require: false
      parameter :per_page, "每页的数量", require: false

      let(:page) { 1 }
      let(:per_page) { 2 }
      example "管理员  用户列表" do
        do_request
        puts response_body
        expect(status).to eq(200)
        # 第一个用户的所有衣柜都未即将到期
        expect(response_body['users'].first['any_chests_about_to_expire']).to be_nil
      end
    end
  end

end
