class Admin::CommentsController < ApplicationController
  def index
    @task = Task.find(params[:task_id])
    @comments = @task.comments

    authorize @comments
  end

  def new
    authorize Comment
  end

  def create
    @comment = Comment.new(comment_params)
    authorize @comment

    if @comment.save
      flash[:notice] = t('actions.updated_with_success')
    else
      flash[:alert] = @comment.errors.full_messages.join(', ')
    end

    redirect_to admin_comments_path(task_id: @comment.task_id)
  end

  def show
    @comment = Comment.find(params[:id])
    authorize @comment
  end

  def edit
    @comment = Comment.find(params[:id])
    @task = @comment.task
    authorize @comment
  end

  def update
    @comment = Comment.find(params[:id])
    authorize @comment

    @comment.assign_attributes(comment_params)

    if @comment.save
      flash[:notice] = t('actions.updated_with_success')
    else
      flash[:alert] = @comment.errors.full_messages.join(', ')
    end
    url = params[:url] || admin_comments_path(task_id: @comment.task_id)
    redirect_to url
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment

    @comment.deleted = true

    if @comment.save
      flash[:notice] = t('actions.updated_with_success')
    else
      flash[:alert] = @comment.errors.full_messages.join(', ')
    end
    url = params[:url] || authenticated_root_path

    redirect_to url
  end

  private
    def comment_params
      params.require(:comment).permit(:id, :text, :user_id, :task_id, :deleted)
    end
end
