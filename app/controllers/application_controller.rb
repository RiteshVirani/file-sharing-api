class ApplicationController < ActionController::API
  before_action :authenticate_user!
  attr_accessor :current_user

  def authenticate_user!
    if request.headers['X-API-TOKEN'].present?
      @current_user = User.find_by(api_token: request.headers['X-API-TOKEN'])
      render(json: { error: 'Invalid API Token' }, status: 403) && return if @current_user.nil?
    else
      render(json: { error: 'Invalid API Token' }, status: 403)
    end
  end
end
