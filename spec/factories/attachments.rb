FactoryGirl.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new("#{Rails.root}/spec/spec_helper.rb") }

    factory :invalid_attachment do
      file nil
    end
  end
end
