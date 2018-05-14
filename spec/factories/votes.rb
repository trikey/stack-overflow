FactoryBot.define do
  factory :vote do
    user
    value 1
    votable { |obj| obj.association(:question) }
  end
end