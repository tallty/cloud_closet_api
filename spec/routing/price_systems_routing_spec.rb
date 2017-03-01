require "rails_helper"

RSpec.describe PriceSystemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/price_systems").to route_to("price_systems#index")
    end

    it "routes to #new" do
      expect(:get => "/price_systems/new").to route_to("price_systems#new")
    end

    it "routes to #show" do
      expect(:get => "/price_systems/1").to route_to("price_systems#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/price_systems/1/edit").to route_to("price_systems#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/price_systems").to route_to("price_systems#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/price_systems/1").to route_to("price_systems#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/price_systems/1").to route_to("price_systems#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/price_systems/1").to route_to("price_systems#destroy", :id => "1")
    end

  end
end
