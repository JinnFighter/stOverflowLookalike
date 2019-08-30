FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"
    user

    trait :with_answers_from_many_users do
      title "MyString"
      body "MyText"

      before(:create) do |instance|
        instance.answers << FactoryGirl.create(:answer, user: User.find(instance.user_id))
        instance.answers << FactoryGirl.create(:answer)
      end
    end

    trait :with_file do
      attachment
    end

    trait :with_invalid_file do
      invalid_attachment
    end
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
