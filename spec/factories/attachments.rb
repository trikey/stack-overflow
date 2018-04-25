FactoryBot.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/fixtures/img.jpg"))}
    attachable nil
  end
end