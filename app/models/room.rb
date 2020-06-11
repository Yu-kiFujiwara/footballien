class Room < ApplicationRecord
    has_many :messages
    has_one :owner, class_name: "User"
    has_one :player, class_name: "User"
end
