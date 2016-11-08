require 'acceptance_helper'

resource "按条件查询预约订单" do
  header "Accept", "application/json"

  get 'query_appointments' do

  	parameter :state, "查询条件,英文字符串，使用逗号隔开每个条件，committed,accepted,unpaid,paid,storing,stored,canceled", required: false
  	parameter :page, "当前页", required: false
    parameter :per_page, "每页的数量", required: false

  	before do
	  	@user = create(:user)
	  	create_list(:appointment, 1, user: @user, aasm_state: "committed")
	  	create_list(:appointment, 1, user: @user, aasm_state: "accepted")
	  	create_list(:appointment, 1, user: @user, aasm_state: "unpaid")
	  	create_list(:appointment, 1, user: @user, aasm_state: "paid")
	  	create_list(:appointment, 1, user: @user, aasm_state: "storing")
	  	create_list(:appointment, 1, user: @user, aasm_state: "stored")
	  	create_list(:appointment, 1, user: @user, aasm_state: "canceled")
		end

		let(:state) {"committed,accepted,unpaid,storing"}

		example "按条件查询预约订单成功,默认查询所有" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end

	end
end
