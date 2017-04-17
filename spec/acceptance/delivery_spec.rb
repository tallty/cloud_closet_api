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
      @stored_garments = create_list(:garment, 3, user: @user, status: 'stored', exhibition_chest: @chest)
      @garments_in_basket = create_list(:garment, 2 , user: @user, status: 'in_basket', exhibition_chest: @chest)
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
          example "【用户】加入衣服至【配送篮】失败， 衣服起始状态错误(不对 错误id报错）" do
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
          example "【用户】移出 配送栏， 衣服起始状态错误" do
            do_request
            puts response_body
            expect(status).to eq(422)
          end
        end
      end
    end

    describe 'About Delivery Order' do 

    end

  end


end