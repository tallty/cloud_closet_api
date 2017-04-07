json.extract! public_msg, :id, :title, :abstract, :content, :public_msg_image
json.public_msg_image public_msg.public_msg_image.try(:image_url, :medium)