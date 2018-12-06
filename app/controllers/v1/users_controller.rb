module V1
  class UsersController < ApplicationController
    skip_before_action :authorize_request, only: :create

  # POST /signup
  # return authenticated token upon signup
  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token, user: user.slice(:id, :email, :name)}
    json_response(response, :created)
  end

  def update
    current_user.name = params[:name]
    current_user.avatar.attach(user_params[:avatar]) if user_params[:avatar]
    current_user.save
    payload = current_user.slice(:id, :email, :name)
    payload['url'] = current_user.avatar.attachment ? url_for(current_user.avatar) : ''
    json_response(payload)
  end

  def favorites
    current_user.favorites
  end

  private

  def user_params
    params.permit(
      :name,
      :id,
      :avatar,
      :email,
      :password,
      :password_confirmation,
      )
  end
end
end
