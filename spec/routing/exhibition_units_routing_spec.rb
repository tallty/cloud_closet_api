require "rails_helper"

RSpec.describe ExhibitionUnitsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/exhibition_units").to route_to("exhibition_units#index")
    end

    it "routes to #new" do
      expect(:get => "/exhibition_units/new").to route_to("exhibition_units#new")
    end

    it "routes to #show" do
      expect(:get => "/exhibition_units/1").to route_to("exhibition_units#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/exhibition_units/1/edit").to route_to("exhibition_units#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/exhibition_units").to route_to("exhibition_units#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/exhibition_units/1").to route_to("exhibition_units#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/exhibition_units/1").to route_to("exhibition_units#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/exhibition_units/1").to route_to("exhibition_units#destroy", :id => "1")
    end

  end
end
