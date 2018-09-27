class Admin::CommentsController < ApplicationController
  def index
    authorize Comment
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
  end

  def show
    @comment = Comment.find(params[:id])
    authorize @comment
  end

  def edit
    @comment = Comment.find(params[:id])
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
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment
  end

  private
    def comment_params
      params.require(:comment).permit(:id, :text, :user_id, :task_id)
    end
end
