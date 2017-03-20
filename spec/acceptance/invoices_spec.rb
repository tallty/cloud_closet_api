require 'acceptance_helper'

resource "开票相关" do
  header "Accept", "application/json"
  user_attrs = FactoryGirl.attributes_for(:user)

  header "X-User-Token", user_attrs[:authentication_token]
  header "X-User-Phone", user_attrs[:phone]

  before do
  	@user = create(:user)
    header "X-User-Token", @user.authentication_token
    header "X-User-Phone", @user.phone
    @user_info = create(:user_info, user: @user, recharge_amount: 200000)
    @invoices = create_list(:invoice, 3, user: @user, amount: 200)
  end

  get '/invoices' do

    example "用户查询 发票记录 列表成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end

  get 'invoices/:id' do

    let(:id) {@invoices.first.id}

    example "用户查询 某发票记录 详情成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end

  post 'invoices' do 

    parameter :title, '发票抬头', required: true, scope: 'invoice'
    parameter :amount, '发票金额', required: true, scope: 'invoice'
    parameter :invoice_type, '发票类型： 普通发票/...', required: true, scope: 'invoice'
    parameter :cel_name, '联系人姓名', required: true, scope: 'invoice'
    parameter :cel_phone, '联系人电话', required: true, scope: 'invoice'
    parameter :postcode, '邮编', required: true, scope: 'invoice'
    parameter :address, '地址', required: true, scope: 'invoice'

    let(:title) { '上海拓体信息科技有限公司' }
    let(:amount) { 666 }
    let(:invoice_type) { '普通发票' }
    let(:cel_name) { '哈哈哈' }
    let(:cel_phone) { '1234567890' }
    let(:postcode) { '363000' }
    let(:address) { '地址-地址-地址-地址-地址-地址' }

    example "用户查询 创建发票记录 成功" do
      do_request
      puts response_body
      expect(status).to eq(201)
    end

    describe '开票失败' do 
      let(:amount) { 6666666666 }
      example "用户查询 创建发票记录 失败（额度不足）" do
        do_request
        puts response_body
        expect(status).to eq(422)
      end
    end
  end
# parameter  :date, '', required: true, scope: 'invoice'
end