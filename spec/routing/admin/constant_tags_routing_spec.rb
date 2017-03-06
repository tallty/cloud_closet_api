require "rails_helper"

RSpec.describe Admin::ConstantTagsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/constant_tags").to route_to("admin/constant_tags#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/constant_tags/new").to route_to("admin/constant_tags#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/constant_tags/1").to route_to("admin/constant_tags#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/constant_tags/1/edit").to route_to("admin/constant_tags#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/constant_tags").to route_to("admin/constant_tags#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/constant_tags/1").to route_to("admin/constant_tags#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/constant_tags/1").to route_to("admin/constant_tags#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/constant_tags/1").to route_to("admin/constant_tags#destroy", :id => "1")
    end

  end
end
