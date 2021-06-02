class Api::V1::SessionsController < ApplicationController

  # POST /sessions
  def create
    @user = User.find_by(username: params[:username])

    if @user&.authenticate(params[:password])
      token = encode_token({user_id: @user.id})

      render json: {user: @user, token: token}
    else
      render json: {error: "Invalid username/password"}
    end
  end
end
