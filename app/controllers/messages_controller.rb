class MessagesController < ApplicationController
  before_action :set_conversation,:set_user2
  before_action :set_message,only: %i[show edit update destroy]
  def index
    @messages=@conversation.messages.eager_load(:user).all
    @message=@conversation.messages.new
  end
  def new

  end
  def edit

  end
  def show

  end
  def create
    @message=@conversation.messages.create(message_params)
    @message.user_id=current_user.id

    respond_to do |format|
      if @message.save
        format.turbo_stream
        #format.html redirect_to user_conversation_messages_path(@user2,@conversation)
      else
        format.turbo_stream
      end
    end
  end
  def update
    respond_to do |format|
      if  @message.update(message_params)
        format.turbo_stream
        #format.html redirect_to user_conversation_messages_path(@user2,@conversation)
      else
        format.html render :edit
      end
    end
  end

  def destroy
    if @message.destroy
      respond_to do |format|
        format.turbo_stream
        #format.html redirect_to user_conversation_messages_path
      end
    end
  end
  private
  def message_params
    params.require(:message).permit(:body,:user_id,:conversation_id)
  end
  def set_conversation
    @conversation=Conversation.find(params[:conversation_id])
  end
  def set_user2
    @user2=User.find(params[:user_id])
  end
  def set_message
    @message=Message.find(params[:id])
  end
end
