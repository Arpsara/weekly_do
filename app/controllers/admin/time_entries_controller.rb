class Admin::TimeEntriesController < ApplicationController
  require 'will_paginate/array'

  before_action :set_time_entry, only: [:show, :edit, :update, :destroy]

  # GET /time_entries
  def index
    authorize TimeEntry

    @projects = current_user.projects.includes(:time_entries)
    @time_entries = []
    @projects.each do |project|
      @time_entries << project.time_entries.search(params[:search], params[:period]).order('created_at DESC')
    end
    @all_time_entries = @time_entries.flatten
    @time_entries = @time_entries.flatten.paginate(:page => params[:page], :per_page => 30)

    respond_to do |format|
      if request.xhr?
        format.html { render partial: "index",
          locals: {
            time_entries: @time_entries
          }
        }
      else
        format.html
      end
    end
  end

  # GET /time_entries/1
  def show
    authorize @time_entry
  end

  # GET /time_entries/new
  def new
    @time_entry = TimeEntry.new

    authorize @time_entry
  end

  # GET /time_entries/1/edit
  def edit
    authorize @time_entry

  end

  # POST /time_entries
  # POST /time_entries.json
  def create
    @time_entry = TimeEntry.new(time_entry_params)
    url =  params[:url] || admin_time_entries_path
    authorize @time_entry

    respond_to do |format|
      if @time_entry.save
        format.html { redirect_to url, notice: t('actions.created_with_success') }
        format.json { render :show, status: :created, location: @time_entry }
      else
        flash[:alert] = @time_entry.errors.full_messages.join(', ')
        format.html { render :new }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_entries/1
  def update
    authorize @time_entry

    respond_to do |format|
      if @time_entry.update(time_entry_params)
        format.html { redirect_to admin_time_entries_path, notice: t('actions.updated_with_success') }
        format.json { render :show, status: :ok, location: @time_entry }
      else
        format.html { render :edit }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_entries/1
  # DELETE /time_entries/1.json
  def destroy
    authorize @time_entry

    @time_entry.destroy
    respond_to do |format|
      format.html { redirect_to admin_time_entries_url,
        notice: t('actions.destroyed_with_success') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_entry
      @time_entry = TimeEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_entry_params
      params.require(:time_entry).permit(:spent_time_field, :price, :user_id, :task_id)
    end
end
