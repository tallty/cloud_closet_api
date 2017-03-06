require "rails_helper"

RSpec.describe ConstantTagsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/constant_tags").to route_to("constant_tags#index")
    end

    it "routes to #new" do
      expect(:get => "/constant_tags/new").to route_to("constant_tags#new")
    end

    it "routes to #show" do
      expect(:get => "/constant_tags/1").to route_to("constant_tags#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/constant_tags/1/edit").to route_to("constant_tags#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/constant_tags").to route_to("constant_tags#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/constant_tags/1").to route_to("constant_tags#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/constant_tags/1").to route_to("constant_tags#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/constant_tags/1").to route_to("constant_tags#destroy", :id => "1")
    end

  end
end
