# frozen_string_literal: true

class SignedJobsController < EntitiesController
  before_action :get_data_for_sidebar, only: :index

  # GET /signed_jobs
  def index
    @signed_jobs = get_signed_jobs(page: page_param, per_page: per_page_param)
    respond_with(@signed_jobs)
  end

  # GET /signed_jobs/1
  def show
    respond_with(@signed_job)
  end

  # POST /signed_jobs/filter
  def filter
    session[:signed_jobs_filter] = params[:status]
    @signed_jobs = get_signed_jobs(page: 1, per_page: per_page_param) # Start one the first page.

    respond_with(@signed_jobs) do |format|
      format.js { render :index }
    end
  end

  # GET /signed_jobs/1/edit
  def edit
    @signed_job.additional_expenses.build(label: "Additional Expenses") if @signed_job.additional_expenses.empty?
    @previous = SignedJob.my(current_user).find_by_id(detect_previous_id) || detect_previous_id if detect_previous_id
    respond_with(@signed_job)
  end

  def update
    if @signed_job.completed?
      @signed_job.errors.add(:base, t(:signed_job_locked))
    else
      @signed_job.update(resource_params)
    end

    get_data_for_sidebar if @signed_job.errors.empty?

    respond_to do |format|
      if @signed_job.errors.empty?
        format.js
        format.html { redirect_to signed_jobs_path }
      else
        format.js { render :edit }
        format.html { redirect_to signed_jobs_path, alert: @signed_job.errors.full_messages.to_sentence }
      end
    end
  end

  private

  #----------------------------------------------------------------------------
  def get_data_for_sidebar
    jobs = SignedJob.my(current_user)
    @signed_job_status_total = ActiveSupport::HashWithIndifferentAccess[
      all: jobs.count,
      new: jobs.where(status: 'new').count,
      preparation: jobs.where(status: 'preparation').count,
      in_progress: jobs.where(status: 'in_progress').count,
      completed: jobs.where(status: 'completed').count,
      canceled: jobs.where(status: 'canceled').count
    ]
  end

  #----------------------------------------------------------------------------
  alias get_signed_jobs get_list_of_records

  #----------------------------------------------------------------------------
  def list_includes
    %i[request_for_quatation additional_expenses tags].freeze
  end

  #----------------------------------------------------------------------------
  def resource_params
    return {} unless params[:signed_job]

    params.require(:signed_job).permit(
      :doc_id,
      :status,
      :incoming_invoice,
      :incoming_additional_invoice,
      :outcoming_invoice,
      :CMR,
      :file,
      :end_of_time_project,
      additional_expenses_attributes: %i[id label incoming_price qty_incoming outcoming_price qty_outcoming _destroy]
    )
  end
end
