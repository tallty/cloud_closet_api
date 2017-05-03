# == Schema Information
#
# Table name: workers
#
#  id                     :integer          not null, primary key
#  email                  :string(191)      default(""), not null
#  phone                  :string(191)      default(""), not null
#  encrypted_password     :string(191)      default(""), not null
#  reset_password_token   :string(191)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(191)
#  last_sign_in_ip        :string(191)
#  authentication_token   :string(30)
#
# Indexes
#
#  index_workers_on_authentication_token  (authentication_token) UNIQUE
#  index_workers_on_email                 (email) UNIQUE
#  index_workers_on_reset_password_token  (reset_password_token) UNIQUE
#

class Worker < ApplicationRecord
  ## Token Authenticatable
  acts_as_token_authenticatable
  
  has_many :offline_recharges

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         authentication_keys: [:phone]

 

  # user phone as the authentication key, so email is not required default
  def email_required?
    false
  end
end
