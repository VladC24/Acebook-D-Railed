# frozen_string_literal: true

require 'pry'

class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def index
    @users = User.all
  end

  def new
    redirect_to user_posts_path(current_user) if !current_user.nil?
    @user = User.new
  end

  def create
    @user = User.new(signup_params)

    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      flash[:success] = 'Welcome to Acebook by D-Railed!'
      (redirect_to user_posts_path(current_user)) && return
    else
      render :new
    end
  end

  private

  def signup_params
    params.require(:user).permit(
      :username,
      :email,
      :password,
      :password_confirmation
    )
  end
end
