FactoryGirl.define do
  factory :answer do
    body "MyText"
    user
    best_answer false

    factory :answer_to_question do
      body "Test_body"
      question
    end
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end


end
