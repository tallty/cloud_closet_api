FactoryGirl.define do
  factory :image do
    photo {Rack::Test::UploadedFile.new('./spec/assets/news.png', 'image/png')}
  end
end
