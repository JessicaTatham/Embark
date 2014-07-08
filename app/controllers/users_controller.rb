class UsersController < ApplicationController

  def index 
    # @user = User.find(session[:id])
  end

  def login
    @user = User.find_by(login_params).try(:authenticate, login_password[:password])
    if @user
      session[:id] = @user.id
      redirect_to users_path
    else
      redirect_to home_path 
    end
  end

  def create
    @user = User.new(signup_params)
    if @user.save
      raise params.inspect
      session[:id] = @user.id
      redirect_to users_path
    else
      redirect_to home_path 
    end
  end

  def logout
  	session.clear
    redirect_to home_path
  end

  def favorites
    FavoritedAdventure.create(adventure_id: params[:data], user_id: session[:id])
    return 200
  end
  
  private

  def login_params
    params.require(:params).permit(:email)
  end

  def login_password
    params.require(:params).permit(:password)
  end

  def signup_params
    params.permit(:email, :password)
  end

  def addAdventure
    if Adventure.makeAdventure(params[:title],params[:description],params[:start_city],params[:duration],nil,params[:image_url],params[:categories])
      redirect_to users_path
    else
      redirect_to home_path
    end
  end
end
