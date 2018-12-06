module V1
  class AuthenticationController < ApplicationController
    skip_before_action :authorize_request, only: :authenticate
  # return auth token once user is authenticated
  def authenticate
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    user = User.find_by(email: auth_params[:email])
    temp_user = user.slice(:id, :email, :name)
    temp_user['url'] = user.avatar.attachment ? url_for(user.avatar) : ''
    json_response(auth_token: auth_token, user: temp_user)
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
end
