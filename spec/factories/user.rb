FactoryGirl.define do
    factory :user do
        name:'owner'
        email:'owner@example.com'
        password:'password'
        password_confirmation:'password'
        job:'owner'
        age:'40'
        sex:'man'
        location:'北海道'
        introduction:'新しいチームを作りました！'
    end
end
      
