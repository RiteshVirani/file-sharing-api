class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[sign_up]
  before_action :validate_password, only: %i[sign_up]
  before_action :find_user_by_id, only: %i[update destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def sign_up
    @user = User.new(sign_up_params)
    if @user.save
      begin
        @user.generate_api_key
        render 'show', status: :ok
        response.headers['X-API-TOKEN'] = @user.api_token
      rescue StandardError
        render json: { error: @user.errors }, status: :unprocessable_entity
      end
    else
      render json: { error: @user.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_update_params)
      render 'show'
    else
      render json: { error: @user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render json: { msg: 'User deleted' }, status: :ok
    else
      render json: @user.errors, status: unprocessable_entity
    end
  end

  private

  def encrypt(password, salt = nil)
    salt = BCrypt::Engine.generate_salt if salt.blank?
    BCrypt::Engine.hash_secret(password, salt)
  end

  def find_user_by_id
    @user = User.find(params[:id])
    render(json: { error: 'User not found' }, status: 404) && return if @user.nil?
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def user_update_params
    params.require(:user).permit(:email)
  end

  def sign_up_params
    permitted_params = params.require(:user).permit(:email)
    permitted_params.merge(password_digest: encrypt(user_params[:password]))
  end

  def validate_password
    reg = /^(?=.*[a-zA-Z0-9]).{6,}$/
    if user_params[:password].nil? || reg.match(user_params[:password]).nil?
      render json: { error: 'Password should contain minimum 6 characters including digits' }, status: 422
    end
  end
end
