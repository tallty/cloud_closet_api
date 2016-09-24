FactoryGirl.define do
  factory :image do
    title "image title"
    photo_type "photo type"   
    photo {Rack::Test::UploadedFile.new('./spec/assets/news.png', 'image/png')}
  end
end
