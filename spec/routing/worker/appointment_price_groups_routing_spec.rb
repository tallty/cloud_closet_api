require "rails_helper"

RSpec.describe Worker::AppointmentPriceGroupsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/worker/appointment_price_groups").to route_to("worker/appointment_price_groups#index")
    end

    it "routes to #new" do
      expect(:get => "/worker/appointment_price_groups/new").to route_to("worker/appointment_price_groups#new")
    end

    it "routes to #show" do
      expect(:get => "/worker/appointment_price_groups/1").to route_to("worker/appointment_price_groups#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/worker/appointment_price_groups/1/edit").to route_to("worker/appointment_price_groups#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/worker/appointment_price_groups").to route_to("worker/appointment_price_groups#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/worker/appointment_price_groups/1").to route_to("worker/appointment_price_groups#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/worker/appointment_price_groups/1").to route_to("worker/appointment_price_groups#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/worker/appointment_price_groups/1").to route_to("worker/appointment_price_groups#destroy", :id => "1")
    end

  end
end
