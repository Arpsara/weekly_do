class Admin::UsersController < ApplicationController
  before_action :find_user, except: [:index, :new, :create]

  def index
    authorize User

    @users = User.all.search(params[:search]).paginate(:page => params[:page], :per_page => 30)

    respond_to do |format|
      gon.push(search_url: admin_users_path(search: params[:search]))
      if request.xhr?
        format.html { render partial: "index",
          locals: {
            users: @users
          }
        }
      else
        format.html
      end
    end
  end

  def show
    authorize @user

    @url = admin_user_path(@user)
  end

  def new
    @user = User.new
    @url = admin_users_path

    authorize @user
  end

  def create
    @user = User.new(user_params)
    @user.skip_password_validation = true

    authorize @user

    if @user.save
      flash[:notice] = t('actions.created_with_success')
      redirect_to admin_users_path
    else
      flash[:alert] = t('words.something_went_wrong', errors: @user.errors.full_messages.join(', '))
      @url = admin_users_path
      render :new
    end
  end

  def edit
    authorize @user

    @url = admin_user_path(@user)
  end

  def update
    authorize @user
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    @user.assign_attributes(user_params)

    if @user.save
      sign_in(@user, bypass: true)
      flash[:notice] = t('actions.updated_with_success')
      redirect_to edit_admin_user_path(@user)
    else
      flash[:alert] = t('words.something_went_wrong', errors: @user.errors.full_messages.join(', '))
      render :edit
    end
  end

  def destroy
    authorize @user

    if @user.destroy
      flash[:notice] = t('actions.destroyed_with_success')
      redirect_to admin_users_path
    else
      flash[:alert] = t('words.something_went_wrong')
      render :back
    end
  end

  private
    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:id, :email, :firstname, :lastname, :password, :password_confirmation, role_ids: [])
    end
end
