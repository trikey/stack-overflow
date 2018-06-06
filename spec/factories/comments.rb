FactoryBot.define do
  factory :comment do
    user nil
    body 'Some comment'
    commentable nil
  end
end