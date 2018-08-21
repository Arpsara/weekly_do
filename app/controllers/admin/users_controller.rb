class Admin::UsersController < ApplicationController
  before_action :find_user, except: [:index, :new, :create]

  def index
    @title = User.model_name.human(count: 2)

    authorize User

    @users = User.visible.search(params[:search]).paginate(:page => params[:page], :per_page => 30)

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

    @user.deleted = true

    if @user.save
      @user.calendar_parameter.update_attributes(deleted: true)
      @user.project_parameters.each do |project_parameter|
        project_parameter.update_attributes(deleted: true)
      end
      @user.costs.each do |cost|
        cost.update_attributes(deleted: true)
      end
      @user.schedules.each do |schedule|
        schedule.update_attributes(deleted: true)
      end
      @user.time_entries.each do |time_entry| time_entry.update_attributes(deleted: true)
      end
      @user.projects.each do |project|
        project.user_ids = project.user_ids - [@user.id]
      end
      @user.tasks.each do |task|
        task.user_ids = task.user_ids - [@user.id]
      end

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
      params.require(:user).permit(:id, :email, :firstname, :lastname, :password, :password_confirmation, :favorite_color, :pomodoro_alert, role_ids: [])
    end
end
