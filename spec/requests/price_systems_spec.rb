require 'rails_helper'

RSpec.describe "PriceSystems", type: :request do
  describe "GET /price_systems" do
    it "works! (now write some real specs)" do
      get price_systems_path
      expect(response).to have_http_status(200)
    end
  end
end
