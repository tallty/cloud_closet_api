require 'rails_helper'

RSpec.describe "ExhibitionChests", type: :request do
  describe "GET /exhibition_chests" do
    it "works! (now write some real specs)" do
      get exhibition_chests_path
      expect(response).to have_http_status(200)
    end
  end
end