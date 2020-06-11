# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    user ""
    room nil
    content "MyText"
  end
end
