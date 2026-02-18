# frozen_string_literal: true

class SignedJobsController < ApplicationController
  before_action :set_current_tab, only: %i[index show edit]
  before_action :load_signed_jobs, only: %i[index]
  before_action :load_signed_job, only: %i[show edit update]

  # GET /signed_jobs
  def index
    respond_with @signed_jobs do |format|
      format.html { @signed_jobs = get_signed_jobs(page: page_param, per_page: per_page_param) }
      format.js   { @signed_jobs = get_signed_jobs(page: page_param, per_page: per_page_param); render :index }
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
    if @signed_job.update(signed_job_params)
      respond_to do |format|
        format.js
        format.html { redirect_to signed_jobs_path }
      end
    else
      respond_to do |format|
        format.js { render :edit }
        format.html { render :edit }
      end
    end
  end

  private

  def get_signed_jobs(options = {})
    query = options[:query] || params[:query]
    @current_query = query

    scope = SignedJob.includes(:request_for_quatation, :additional_expenses)
    scope = scope.text_search(query) if query.present?
    scope = scope.order(created_at: :desc)
                 .paginate(page: options[:page], per_page: options[:per_page])

    @search_results_count = scope.except(:offset, :limit).count
    scope
  end

  def load_signed_jobs
    @signed_jobs = get_signed_jobs(page: page_param, per_page: per_page_param)
    @current_query = params[:query]
  end

  def load_signed_job
    @signed_job = SignedJob.includes(:request_for_quatation, :additional_expenses).find(params[:id])
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
      :doc_id,
      :status,
      :additional_expenses,
      :incoming_invoice,
      :incoming_additional_invoice,
      :outcoming_invoice,
      :CMR,
      :file,
      :end_of_time_project,
      additional_expenses_attributes: [:id, :label, :incoming_price, :qty_incoming, :outcoming_price, :qty_outcoming, :_destroy]
    )
  end
end
