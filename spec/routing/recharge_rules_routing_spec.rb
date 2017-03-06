require "rails_helper"

RSpec.describe RechargeRulesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/recharge_rules").to route_to("recharge_rules#index")
    end

    it "routes to #new" do
      expect(:get => "/recharge_rules/new").to route_to("recharge_rules#new")
    end

    it "routes to #show" do
      expect(:get => "/recharge_rules/1").to route_to("recharge_rules#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/recharge_rules/1/edit").to route_to("recharge_rules#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/recharge_rules").to route_to("recharge_rules#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/recharge_rules/1").to route_to("recharge_rules#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/recharge_rules/1").to route_to("recharge_rules#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/recharge_rules/1").to route_to("recharge_rules#destroy", :id => "1")
    end

  end
end
