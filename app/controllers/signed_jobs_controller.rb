# frozen_string_literal: true

class SignedJobsController < EntitiesController
  # GET /signed_jobs
  def index
    @signed_jobs = get_signed_jobs(page: page_param, per_page: per_page_param)
    respond_with(@signed_jobs)
  end

  # GET /signed_jobs/1
  def show
    respond_with(@signed_job)
  end

  # GET /signed_jobs/1/edit
  def edit
    @previous = SignedJob.my(current_user).find_by_id(detect_previous_id) || detect_previous_id if detect_previous_id
    respond_with(@signed_job)
  end

  def update
    if @signed_job.completed?
      @signed_job.errors.add(:base, t(:signed_job_locked))
    else
      @signed_job.update(resource_params)
    end

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
  alias get_signed_jobs get_list_of_records

  #----------------------------------------------------------------------------
  def list_includes
    %i[request_for_quatation additional_expenses tags].freeze
  end

  #----------------------------------------------------------------------------
  def set_current_tab
    @current_tab = 'Signed Jobs'
  end

  #----------------------------------------------------------------------------
  def resource_params
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
      additional_expenses_attributes: %i[id label incoming_price qty_incoming outcoming_price qty_outcoming _destroy]
    )
  end
end
