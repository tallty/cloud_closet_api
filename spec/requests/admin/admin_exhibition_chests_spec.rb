require 'rails_helper'

RSpec.describe "Admin::ExhibitionChests", type: :request do
  describe "GET /admin_exhibition_chests" do
    it "works! (now write some real specs)" do
      get admin_exhibition_chests_path
      expect(response).to have_http_status(200)
    end
  end
end
