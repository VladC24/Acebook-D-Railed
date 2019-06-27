# frozen_string_literal: true

require 'pry'
class PostsController < ApplicationController
  before_action :can_edit, only: %i[edit update destroy]
  before_action :check_time, only: %i[edit update]

  def index
    @posts = Post.where(recipient_id: params[:user_id]).order('created_at DESC')
  end

  def show
    @post = Post.find(params[:post_id])
  end

  def new
    @post = Post.new
    @recipient_id = params[:user_id]
  end

  def create
    @post = Post.new(post_params.merge(user_id: session[:user_id]))
    if @post.valid?
      @post.save
      redirect_to user_posts_path(post_params[:recipient_id])
    else 
      render :new
    end 
  end

  def destroy
    @post = Post.find(params[:id])
    @recipient_id = @post.recipient_id
    @post.destroy

    redirect_to user_posts_path(@recipient_id)
  end

  def edit
    check_time
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to user_posts_path(post_params[:recipient_id])
  end

  private

  def get_username(user_id)
    User.find(user_id).username
  end

  def post_params
    params.require(:post).permit(:message, :recipient_id)
  end

  def can_edit
    @post = Post.find(params[:id])
    unless @post && current_user && current_user.can_edit?(@post)
      flash[:edit_not_allowed] =
        'Post can only be deleted or edited by its author!'
      redirect_to user_posts_path(@post.recipient_id)
    end
  end

  def check_time
    if Time.now > @post.created_at + 10.minutes
      flash[:created_at] =
        'Post can only be edited 10 min after it has been created'
      redirect_to user_posts_path(@post.recipient_id)
    end
  end

  def wall
    if User.all == []
      @wall = nil
    else
      @wall ||= User.find(params[:user_id])
    end
  end

  helper_method :get_username, :wall
end
