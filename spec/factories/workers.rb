# == Schema Information
#
# Table name: workers
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  phone                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  authentication_token   :string(30)
#
# Indexes
#
#  index_workers_on_authentication_token  (authentication_token) UNIQUE
#  index_workers_on_email                 (email) UNIQUE
#  index_workers_on_reset_password_token  (reset_password_token) UNIQUE
#

FactoryGirl.define do
  factory :worker, class: :worker do
    phone "1861659101"
    password "abcd.1234"
    authentication_token "qwertyuiop2"
  end 
end
