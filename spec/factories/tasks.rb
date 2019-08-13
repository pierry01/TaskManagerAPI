FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    done { false }
    deadline { "2019-08-13 18:22:58" }
    user { nil }
  end
end
