require 'rails_helper'

RSpec.describe "Admin::ConstantTags", type: :request do
  describe "GET /admin_constant_tags" do
    it "works! (now write some real specs)" do
      get admin_constant_tags_path
      expect(response).to have_http_status(200)
    end
  end
end
