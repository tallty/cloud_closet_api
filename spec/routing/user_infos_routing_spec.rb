require "rails_helper"

RSpec.describe UserInfosController, type: :routing do
  describe "routing" do

    it "routes to #show" do
      expect(:get => "/user_info").to route_to("user_infos#show")
    end

    it "routes to #update via PUT" do
      expect(:put => "/user_info").to route_to("user_infos#update")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/user_info").to route_to("user_infos#update")
    end

  end
end
