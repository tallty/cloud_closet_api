require 'rails_helper'

RSpec.describe "Worker::AppointmentPriceGroups", type: :request do
  describe "GET /worker_appointment_price_groups" do
    it "works! (now write some real specs)" do
      get worker_appointment_price_groups_path
      expect(response).to have_http_status(200)
    end
  end
end
