require "rails_helper"

RSpec.describe ExhibitionChestsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/exhibition_chests").to route_to("exhibition_chests#index")
    end

    it "routes to #new" do
      expect(:get => "/exhibition_chests/new").to route_to("exhibition_chests#new")
    end

    it "routes to #show" do
      expect(:get => "/exhibition_chests/1").to route_to("exhibition_chests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/exhibition_chests/1/edit").to route_to("exhibition_chests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/exhibition_chests").to route_to("exhibition_chests#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/exhibition_chests/1").to route_to("exhibition_chests#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/exhibition_chests/1").to route_to("exhibition_chests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/exhibition_chests/1").to route_to("exhibition_chests#destroy", :id => "1")
    end

  end
end
