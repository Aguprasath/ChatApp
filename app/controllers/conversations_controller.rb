class ConversationsController < ApplicationController
  before_action :set_other_user

  def index
    @conversations=Conversation.where('(user1_id = :other_user_id AND user2_id = :current_user_id) OR (user1_id = :current_user_id AND user2_id = :other_user_id)', other_user_id: @other_user.id, current_user_id: current_user.id)
  end
  def new
    @conversation=current_user.conversations_as_current_user.new
  end

  def create
    @conversation=current_user.conversations_as_current_user.create(conversation_params)
    @conversation.user2_id=@other_user.id

      if @conversation.save
        Turbo::Streams::ActionBroadcastJob.perform_later("conversations",action: :append, target: "conversations", partial: "conversations/conversation",  locals: { conversation: @conversation,user: current_user })
        redirect_to user_conversation_messages_path(@other_user,@conversation)
      else
         render :new, status: :unprocessable_entity
      end
 end

  def search
    @searched_conversations=Conversation.where('title like ? ',"%#{params[:title]}%")
  end

  private

  def conversation_params
    params.require(:conversation).permit(:user,:title)
  end
  def set_other_user
     @other_user=User.find(params[:user_id])
  end

end
