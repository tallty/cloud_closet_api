require 'rails_helper'

RSpec.describe "ConstantTags", type: :request do
  describe "GET /constant_tags" do
    it "works! (now write some real specs)" do
      get constant_tags_path
      expect(response).to have_http_status(200)
    end
  end
end
