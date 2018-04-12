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
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
