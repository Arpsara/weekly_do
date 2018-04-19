class Admin::TimeEntriesController < ApplicationController
  include TimeHelper
  require 'will_paginate/array'

  before_action :set_time_entry, only: [:show, :edit, :update, :destroy]

  # GET /time_entries
  def index
    authorize TimeEntry
    if params[:project_ids].blank?
      @projects = current_user.projects.includes(:time_entries)
    else
      @projects = current_user.projects.where(id: params[:project_ids]).includes(:time_entries)      
    end
    @time_entries = []

    @time_entries << current_user.time_entries.where(task_id: nil).order('created_at DESC')

    @projects.each do |project|
      @time_entries << project.time_entries.search(params[:search], {period: params[:period]}).order('created_at DESC')
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

    gon.push( {
      project_tasks_url: admin_project_tasks_url
    })
  end

  # GET /time_entries/1/edit
  def edit
    authorize @time_entry

    gon.push( {
      project_tasks_url: admin_project_tasks_url
    })
  end

  # POST /time_entries
  # POST /time_entries.json
  def create
    @time_entry = TimeEntry.new(time_entry_params)
    url =  params[:url] || admin_time_entries_path
    authorize @time_entry

    if must_calculate_spent_time?(params)
      @time_entry.spent_time_field = set_time_from_start_and_end(@time_entry, params)
    end

    start_at = params[:time_entry][:start_at] || Time.now

    @time_entry.start_at = "#{params[:time_entry][:date]} #{start_at}".to_datetime.change(offset: '+0200')

    unless params[:time_entry][:end_at].blank?
      @time_entry.end_at = "#{params[:time_entry][:date]} #{params[:time_entry][:end_at]}".to_datetime.change(offset: '+0200')
    end

    respond_to do |format|
      if @time_entry.save
        @timer_start_at = 0
        if request.xhr?
          format.json { render json: { time_entry_id: @time_entry.id } }
        else
          format.html { redirect_to url, notice: t('actions.saved_time_entry_with_success', spent_time: readable_time(@time_entry.spent_time) ) }
        end
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

    @time_entry.assign_attributes(time_entry_params)

    if params[:time_entry][:in_pause] == "true"
      spent_time_to_add = ((Time.now - @time_entry.start_at) / 60).to_i
      @time_entry.spent_time_field = (@time_entry.spent_time + spent_time_to_add).to_s
    elsif must_calculate_spent_time?(params)
      @time_entry.spent_time_field = set_time_from_start_and_end(@time_entry, params)
    end

    unless params[:time_entry][:start_at].blank?
      @time_entry.start_at = "#{params[:time_entry][:date]} #{params[:time_entry][:start_at]}".to_datetime.change(offset: '+0200')
    end
    unless params[:time_entry][:end_at].blank?
      @time_entry.end_at = "#{params[:time_entry][:date]} #{params[:time_entry][:end_at]}".to_datetime.change(offset: '+0200')
    end


    url = params[:url]
    url ||= admin_time_entries_path

    respond_to do |format|
      if @time_entry.save
        @timer_start_at = 0

        format.html { redirect_to url, notice: t('actions.saved_time_entry_with_success', spent_time: readable_time(@time_entry.spent_time) ) }
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
      params.require(:time_entry).permit(:spent_time_field, :price, :start_at, :end_at, :comment, :in_pause, 
        :current, :date, :user_id, :task_id, task_attributes: [ :id, :done ] )
    end

    def set_time_from_start_and_end(time_entry, params)
      time = (( params[:time_entry][:end_at].to_datetime.to_f - params[:time_entry][:start_at].to_datetime.to_f ) / 60 / 60).to_s

      time ||= time_entry.try(:spent_time)
    end

    def set_end_at(params)
      params[:time_entry][:start_at].to_datetime + convert_in_minutes(params[:time_entry][:spent_time_field].to_s).minutes
    end

    def must_calculate_spent_time?(params)
      return true if !params[:time_entry][:start_at].blank? && !params[:time_entry][:end_at].blank? && no_spent_time?(params[:time_entry][:spent_time_field])
    end

    def no_spent_time?(spent_time_field)
      return true if spent_time_field.blank? || spent_time_field.to_s == '0' || spent_time_field == "0h00"
    end
end
