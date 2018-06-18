FactoryBot.define do
  factory :comment do
    user nil
    body 'Some comment'
    commentable { |obj| obj.association(:question) }
  end
end