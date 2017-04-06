class AddMsgTypeToUserMsg < ActiveRecord::Migration[5.0]
  def change
    add_column :user_msgs, :msg_type, :string
  end
end
