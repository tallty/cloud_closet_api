require 'rails_helper'

RSpec.describe "ExhibitionUnits", type: :request do
  describe "GET /exhibition_units" do
    it "works! (now write some real specs)" do
      get exhibition_units_path
      expect(response).to have_http_status(200)
    end
  end
end
