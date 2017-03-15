class AddCreditToPingRequestAndFixTheSameCloumnNameInUserInfo < ActiveRecord::Migration[5.0]
  def change
  	add_column :ping_requests, :credit, :integer
  	rename_column :user_infos, :credits, :credit
  end
end
