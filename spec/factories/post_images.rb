FactoryBot.define do
  factory :post_image do
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/files/cat.jpg") }
  end
end
