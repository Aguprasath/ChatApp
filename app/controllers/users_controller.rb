# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def search
    unless params[:username].empty?
      @searched_users = User.search_users(params[:username], current_user.id)
    end
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end
end
