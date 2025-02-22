class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: :create
  before_action :find_user, only: :create

  # POST /users/sign_in
  def create
    if @user&.authenticate(user_params[:password])
      @user.generate_api_key
      render 'users/show', status: :ok
      response.headers['X-API-TOKEN'] = @user.api_token
    else
      render json: { error: 'Invalid login credentials' },
             status: :unprocessable_entity
    end
  end

  # DELETE /users/sign_out
  def destroy
    ActiveRecord::Base.transaction do
      current_user.sign_out!
      render json: { msg: 'Logout Successfully' }, status: :ok
    end
  rescue StandardError => e
    render json: { error: e }, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def find_user
    @user = User.find_by(email: user_params[:email])
  end
end
