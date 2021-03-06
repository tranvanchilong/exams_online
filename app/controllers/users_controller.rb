class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :selecting]
  before_action :correct_user, only: [:edit, :update, :show, :selecting]

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @count_cart = Examcart.where(user_id: session[:user_id]).count
    @user_exams = @user.user_exams.includes(:exam) 
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in(@user)
      flash[:success] = t "controller.user.flash_success"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    flash[:success] = "Profile updated" if @user.update(user_params)
    render :edit
  end

  def selecting
    @title = "Selecting"
    @users = @user.selecting.paginate(page: params[:page])
    render = 'show_select'
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :address,
                                 :password_confirmation,
                                 image_attributes: %i[id image_url imageable _destroy]
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = "Please log in."
    redirect_to login_url
  end

  def log_in(user)
    session[:user_id] = user.id
  end
end
