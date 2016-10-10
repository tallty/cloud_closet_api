# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  address    :string
#  name       :string
#  phone      :string
#  number     :integer
#  date       :date
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_appointments_on_user_id  (user_id)
#

class Appointment < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: "AppointmentItem", dependent: :destroy

  def create_template_message
    openid = "olclvwLH5UXJpaTbe-xhT7oPWJSI"
    template = {
      template_id: "6M5zwt6mJeqk6E29HnVj2qdlyA68O9E-NNP4voT1wBU",
      url: "http://www.baidu.com",
      topcolor: "#FF0000",
      data: {
        first: {
          value: "亲，您有新预约订单，请注意查收。",
          color: "#0A0A0A"
        },
        keyword1: {
          value: "乐存好衣",
          color: "#CCCCCC"
        },
        keyword2: {
          value: "13825688888",
          color: "#CCCCCC"
        },
        keyword3: {
          value: "DS20140808E708500",
          color: "#CCCCCC"
        },
        keyword4: {
          value: "已预约",
          color: "#CCCCCC"
        },
        keyword5: {
          value: "上门评估",
          color: "#CCCCCC"
        },
        remark: {
          value: "上门时间是2016-10-12，请安排好您的时间",
          color: "#173177"
        }
      }
    }
    response = Faraday.post 'http://wechat-api.tallty.com/cloud_closet_wechat/template_message',
      { openid: openid, template: template}
    puts response.body
  end
end
