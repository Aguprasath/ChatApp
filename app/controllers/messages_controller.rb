class MessagesController < ApplicationController
  before_action :set_conversation
  before_action :set_other_user
  before_action :set_message,only: %i[show edit update destroy]


  def index
    @messages=@conversation.messages.eager_load(:user).all
    @message=@conversation.messages.new
  end
  def new
    @message=Message.new
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
        format.turbo_stream do
           Turbo::Streams::ActionBroadcastJob.perform_later("messages",action: :append, target: "messages", partial: "messages/message",  locals: { message: @message })
          end
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@message, partial: "messages/form", locals: { message: @message }) }
      end
    end
  end
  def update
      respond_to do |format|
      if  !@message.update(message_params)
        format.turbo_stream do
           turbo_stream.delete(@message)
           end
      end
    end
  end

  def destroy
    if !@message.destroy
      redirect_to user_conversation_messages_path
    end

  end
  private
  def message_params
    params.require(:message).permit(:body,:user_id,:conversation_id)
  end
  def set_conversation
    @conversation=Conversation.find(params[:conversation_id])
  end
  def set_other_user
    @other_user=User.find(params[:user_id])
  end
  def set_message
    @message=Message.find(params[:id])
  end
end
