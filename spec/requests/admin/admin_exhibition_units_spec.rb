require 'rails_helper'

RSpec.describe "Admin::ExhibitionUnits", type: :request do
  describe "GET /admin_exhibition_units" do
    it "works! (now write some real specs)" do
      get admin_exhibition_units_path
      expect(response).to have_http_status(200)
    end
  end
end
