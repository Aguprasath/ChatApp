class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  validates :body,presence: true
   # after_create_commit -> { broadcast_append_to "messages_list" }
   # after_update_commit -> { broadcast_replace_later_to "messages_list" }
   # after_destroy_commit -> { broadcast_remove_to "messages_list" }

end
