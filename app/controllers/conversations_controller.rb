# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :set_other_user

  def index
    @conversations = Conversation.between_users(current_user.id, @other_user.id)
  end

  def new
    @conversation = current_user.conversations_as_current_user.new
  end

  def create
    @conversation = current_user.conversations_as_current_user.create(conversation_params)
    @conversation.user2_id = @other_user.id

    if @conversation.save
      Turbo::Streams::ActionBroadcastJob.perform_later('conversations', action: :append, target: 'conversations',
                                                                        partial: 'conversations/conversation', locals: { conversation: @conversation, user: current_user })
      redirect_to user_conversation_messages_path(@other_user, @conversation)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def search
    if params[:title].present?
      title = params[:title].strip
      @conversations = Conversation.between_users(current_user.id, @other_user.id)
      @searched_conversations = @conversations.search_by_title(title)
      @searched_conversation_messages = @conversations.eager_load(:messages).search_conversation_messages_by_body(
        current_user.id, @other_user.id, title
      )

    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:user, :title)
  end

  def set_other_user
    @other_user = User.find(params[:user_id])
  end
end
