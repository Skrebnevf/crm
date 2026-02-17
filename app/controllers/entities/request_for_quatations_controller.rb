# frozen_string_literal: true

class RequestForQuatationsController < EntitiesController
  before_action :get_data_for_sidebar, only: :index

  # GET /request_for_quatations
  #----------------------------------------------------------------------------
  def index
    @request_for_quatations = get_request_for_quatations(page: page_param)

    respond_with @request_for_quatations do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @request_for_quatations }
    end
  end

  # GET /request_for_quatations/1
  #----------------------------------------------------------------------------
  def show
    @comment = Comment.new
    @timeline = timeline(@request_for_quatation)
    respond_with(@request_for_quatation)
  end

  # GET /request_for_quatations/new
  #----------------------------------------------------------------------------
  def new
    @request_for_quatation.attributes = { user: current_user }
    respond_with(@request_for_quatation)
  end

  # GET /request_for_quatations/1/edit
  #----------------------------------------------------------------------------
  def edit
    @previous = RequestForQuatation.my(current_user).find_by_id(detect_previous_id) || detect_previous_id if detect_previous_id
    respond_with(@request_for_quatation)
  end

  # POST /request_for_quatations
  #----------------------------------------------------------------------------
  def create
    respond_with(@request_for_quatation) do |_format|
      if @request_for_quatation.save
        if called_from_index_page?
          @request_for_quatations = get_request_for_quatations
          get_data_for_sidebar
        else
          get_data_for_sidebar
        end
      end
    end
  end

  # PUT /request_for_quatations/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@request_for_quatation) do |_format|
      if @request_for_quatation.update(resource_params)
        update_sidebar
      end
    end
  end

  # DELETE /request_for_quatations/1
  #----------------------------------------------------------------------------
  def destroy
    @request_for_quatation.destroy

    respond_with(@request_for_quatation) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # GET /request_for_quatations/redraw                                       AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:request_for_quatations_per_page] = per_page_param if per_page_param

    # Sorting and naming only: set the same option for Contacts if the hasn't been set yet.
    if params[:sort_by]
      current_user.pref[:request_for_quatations_sort_by] = RequestForQuatation.sort_by_map[params[:sort_by]]
    end
    if params[:naming]
      current_user.pref[:request_for_quatations_naming] = params[:naming]
    end

    @request_for_quatations = get_request_for_quatations(page: 1, per_page: per_page_param) # Start one the first page.
    set_options # Refresh options

    respond_with(@request_for_quatations) do |format|
      format.js { render :index }
    end
  end

  # POST /request_for_quatations/filter                                      AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:request_for_quatations_filter] = params[:status]
    @request_for_quatations = get_request_for_quatations(page: 1, per_page: per_page_param) # Start one the first page.

    respond_with(@request_for_quatations) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias get_request_for_quatations get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      if called_from_index_page? # Called from RequestForQuatations index.
        get_data_for_sidebar
        @request_for_quatations = get_request_for_quatations
        if @request_for_quatations.blank?
          # If no request_for_quatation on this page then try the previous one.
          # and reload the whole list even if it's empty.
          @request_for_quatations = get_request_for_quatations(page: current_page - 1) if current_page > 1
          render(:index) && return
        end
      else # Called from related asset.
        self.current_page = 1
      end
    else # :html destroy
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @request_for_quatation.name)
      redirect_to request_for_quatations_path
    end
  end

  #----------------------------------------------------------------------------
  def get_data_for_sidebar
    @request_for_quatation_status_total = HashWithIndifferentAccess[
                                          all: RequestForQuatation.my(current_user).count,
                                          other: 0
    ]
  end

  #----------------------------------------------------------------------------
  def update_sidebar
    get_data_for_sidebar
  end

  #----------------------------------------------------------------------------
  def resource_params
    params.require(:request_for_quatation).permit(
      :user_id,
      :client,
      :from,
      :to,
      :readiness_date,
      :what,
      :request_type,
      :comment,
      :price_netto,
      :payment_terms,
      :transit_time,
      :preadvise,
      :free_time,
      :demmurage_rate,
      :valid_till,
      :accepted,
      :denied,
      :reason,
      :assign_to_procurement,
      :assign_to_sales,
      :total_price,
      :income_payment_to,
      :outcome_payment_from
    )
  end
end
