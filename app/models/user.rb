class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :conversations_as_user1, class_name: 'Conversation', foreign_key: 'user1_id', dependent: :destroy
  has_many :conversations_as_user2, class_name: 'Conversation', foreign_key: 'user2_id', dependent: :destroy

end
