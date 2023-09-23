class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  validates :body,presence: true
  broadcasts_to ->(messgae) { "messages" }, inserts_by: :append

end
