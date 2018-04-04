FactoryBot.define do
  factory :answer do
    question
    body 'Answer for question'
  end

  factory :invalid_answer, class: 'Answer' do
    question
    body nil
  end
end
