require 'rails_helper'

RSpec.describe "RechargeRules", type: :request do
  describe "GET /recharge_rules" do
    it "works! (now write some real specs)" do
      get recharge_rules_path
      expect(response).to have_http_status(200)
    end
  end
end
