# frozen_string_literal: true

class SignedJobsController < ApplicationController
  before_action :set_current_tab, only: %i[index show edit]
  before_action :load_signed_jobs, only: %i[index]
  before_action :load_signed_job, only: %i[show edit update]

  # GET /signed_jobs
  def index
    respond_with @signed_jobs do |format|
      format.html { @signed_jobs = get_signed_jobs(page: page_param, per_page: per_page_param) }
    end
  end

  # GET /signed_jobs/1
  def show
    respond_with(@signed_job)
  end

  # GET /signed_jobs/1/edit
  def edit
    @previous = SignedJob.find_by_id(detect_previous_id) || detect_previous_id if detect_previous_id
    respond_with(@signed_job)
  end

  # GET /signed_jobs/redraw                                       AJAX
  def redraw
    current_user.pref[:signed_jobs_per_page] = per_page_param if per_page_param

    @signed_jobs = get_signed_jobs(page: 1, per_page: per_page_param)

    respond_with(@signed_jobs) do |format|
      format.js { render :index }
    end
  end

  # POST /signed_jobs/filter                                      AJAX
  def filter
    session[:signed_jobs_filter] = params[:status]
    @signed_jobs = get_signed_jobs(page: 1, per_page: per_page_param)

    respond_with(@signed_jobs) do |format|
      format.js { render :index }
    end
  end

  # PATCH/PUT /signed_jobs/1
  def update
    respond_with(@signed_job) do |_format|
      @signed_job.update(signed_job_params)
    end
  end

  private

  def get_signed_jobs(options = {})
    @signed_jobs ||=
      SignedJob.includes(:request_for_quatation)
               .order(created_at: :desc)
               .paginate(page: options[:page], per_page: options[:per_page])

    @search_results_count = SignedJob.count
    @signed_jobs
  end

  def load_signed_jobs
    @signed_jobs = get_signed_jobs(page: page_param, per_page: per_page_param)
  end

  def load_signed_job
    @signed_job = SignedJob.includes(:request_for_quatation).find(params[:id])
  end

  def set_current_tab
    @current_tab = 'Signed Jobs'
  end

  def page_param
    page = params[:page]&.to_i
    [0, page].max if page
  end

  def per_page_param
    params[:per_page]&.to_i&.clamp(1, 200)
  end

  def signed_job_params
    return {} unless params[:signed_job]

    params.require(:signed_job).permit(
      :status,
      :additional_expenses,
      :incoming_invoice,
      :incoming_additional_invoice,
      :outcoming_invoice,
      :CMR,
      :end_of_time_project
    )
  end
end
