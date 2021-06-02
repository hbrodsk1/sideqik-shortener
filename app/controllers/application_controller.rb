class ApplicationController < ActionController::API
  SECRET_KEY = Rails.application.secrets.secret_key_base

  private

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token(token)
    JWT.decode(token, SECRET_KEY)
  end

  def decoded_token
    header = request.headers['authorization']
    token = header.split(' ').last if header

    begin
      JWT.decode(token, SECRET_KEY)
    rescue
      'Something went wrong while decoding JWT token'
    end
  end

  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]['user_id']

      @user = User.find_by(id: user_id)
    end
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in_user
  end
end
