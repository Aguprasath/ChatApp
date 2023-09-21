class ConversationsController < ApplicationController
  before_action :set_user2 if @user2.nil?
  before_action :set_conversation, only: %i[show edit update destroy]

  def index
    @conversations=Conversation.where('(user1_id = :user_id AND user2_id = :current_user_id) OR (user1_id = :current_user_id AND user2_id = :user_id)', user_id: @user2.id, current_user_id: current_user.id)
  end
  def new
    @conversation=current_user.conversations_as_user1.new
  end
  def show

  end
  def edit

  end
  def create
    @conversation=current_user.conversations_as_user1.create(conversation_params)
    @conversation.user2_id=@user2.id
    if @conversation.save
      redirect_to user_conversations_path
    else
      render :new
    end
  end

  def update

    if @conversation.update(conversation_params)
      redirect_to user_conversations_path
    else
      render :edit
    end

  end
  def destroy

  end
  private
  def set_conversation
    @conversation=Conversation.find(params[:id])
  end
  def conversation_params
    params.require(:conversation).permit(:user,:title)
  end
  def set_user2
    @user2=User.find(params[:user_id])
  end

end
