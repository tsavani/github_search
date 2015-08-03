class UsersController < ApplicationController
  def index
  end

  def get_user
  	render json: User.all.to_json
  end

  def add_user
  	@user = User.new({:user => "#{params[:user].strip}"}) 
    @user.save! 
    render json: User.all.to_json
  end

  def delete_user
  	@user = User.find("#{params[:id]}")
    @user.destroy
    render json: User.all.to_json
  end
end
