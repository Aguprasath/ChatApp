# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :user1, class_name: 'User', foreign_key: 'user1_id'
  belongs_to :user2, class_name: 'User', foreign_key: 'user2_id'
  has_many :messages, dependent: :destroy

  validates :title, presence: true

  scope :between_users, lambda { |current_user_id, other_user_id|
    where('(user1_id = :user1_id AND user2_id = :user2_id) OR (user1_id = :user2_id AND user2_id = :user1_id)',
          user1_id: current_user_id, user2_id: other_user_id)
  }
  scope :search_by_title, ->(title) { where('title LIKE ?', "%#{title}%") }
  scope :search_conversation_messages_by_body, ->(user_1, user_2, title) {
    where('(((conversations.user1_id = :user_1 and conversations.user2_id = :user_2) or (conversations.user1_id = :user_2 and conversations.user2_id = :user_1 ) ) and messages.body like :title)', user_1: user_1, user_2: user_2, title: "%#{title}%")
  }
end
