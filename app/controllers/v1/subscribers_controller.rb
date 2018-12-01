module V1
  class SubscribersController < ApplicationController
    before_action :set_comic, only: [:index, :show, :create, :update, :destroy]
    before_action :set_subscribers, only: [:index, :show]
    before_action :set_favorites, only: [:index_favorites, :show_favorites]
    skip_before_action :authorize_request, only: [:index, :show]

  # GET /comic/:comic_id/subscribers
  def index
    payload = []
    @subscribers.each do |subscriber|
      temp = subscriber.attributes
      temp['name'] = User.find(subscriber.user_id).name
      payload.push(temp)
    end
    json_response(payload)
  end

  # GET /comic/:comic_id/subscribers/:id
  def show
    subscriber = @comic.subscribers.find(params[:id])
    json_response(subscriber)
  end

  # POST /comic/:comic_id/subscribers
  def create
    subscriber = @comic.subscribers.create(user: current_user, is_blocked: false)
    json_response(subscriber, :created)
  end

  # PUT /comic/:comic_id/subscribers/:id
  def update
    subscriber = @comic.subscribers.find(params[:id])
    subscriber.update(subscriber_params[:is_blocked]) if (current_user.id == @comic.user_id)
    head :no_content

    json_response(subscriber)
  end

  # DELETE /comic/:comic_id/subscribers/:id
  def destroy
    subscriber = @comic.subscribers.find(:id)
    subscriber.destroy if (current_user.id == subscriber.user_id)
    head :no_content
  end

  # GET /favorites
  def index_favorites
    payload = []
    @favorites.each do |favorite|
      temp = favorite.slice(:comic_id)
      comic = Comic.find(favorite.comic_id)
      temp['name'] = comic.name
      temp["url"] = comic.cover.attachment ? url_for(comic.cover) : ''
      payload.push(temp)
    end
    json_response(payload)
  end

  # GET /favorites/:comic_id
  def show_favorites
    favorite = current_user.subscribers.exists?(:comic_id => params[:comic_id])
    json_response(favorite)
  end

  # POST /favorites/:comic_id
  def create_favorites
    comic = Comic.find(params[:comic_id])
    favorite = current_user.subscribers.create(comic: comic, is_blocked: false)
    json_response(favorite, :created)
  end

  def update_favorites
    comic = Comic.find(params[:comic_id])
    user = User.find(params[:user_id])
    subscriber = comic.subscribers.find_by(user_id: params[:user_id], comic_id: params[:comic_id])
    subscriber.destroy if (current_user.id == comic.user_id)
    head :no_content
  end

  # DELETE /favorites/:comic_id
  def destroy_favorites
    favorite = current_user.subscribers.find_by(comic_id: params[:comic_id])
    favorite.destroy if (current_user.id == favorite.user_id)
    head :no_content
  end

  private

  private

  def subscriber_params
    params.permit(:is_blocked, :id, :comic_id, :user_id)
  end

  def set_comic
    @comic = Comic.find(params[:comic_id])
  end

  def set_subscribers
    @subscribers = Subscriber.where(comic_id: params[:comic_id])
  end

  def set_favorites
    @favorites = Subscriber.where(user_id: current_user.id).where(is_blocked: false)
  end
end
end
