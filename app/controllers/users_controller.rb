class UsersController < ApplicationController

  def index
    @users=User.all
  end
  def search
    if(params[:username].present?)
      @searched_users=User.where("(username like ? or email like ? ) and id!=?","%#{(params[:username]).strip}%","%#{(params[:username]).strip}%",current_user.id)
    end
    end
  private

  def user_params
    params.require(:user).permit(:username)
  end

end
