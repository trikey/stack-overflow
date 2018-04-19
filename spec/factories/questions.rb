FactoryBot.define do
  sequence :title do |n|
    "My#{n}String"
  end

  sequence :body do |n|
    "My#{n}Body"
  end

  factory :question do
    user
    title
    body

    factory :question_with_answers do
      transient do
        answers_count 2
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question, user: question.user)
      end
    end
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
