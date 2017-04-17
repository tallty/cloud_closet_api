require 'rails_helper'

RSpec.describe DeliveryOrder, type: :model do
  it { should belong_to :user }
end
