FactoryBot.define do
  factory :answer do
    user
    question
    body 'Answer for question'
  end

  factory :invalid_answer, class: 'Answer' do
    user
    question
    body nil
  end
end
