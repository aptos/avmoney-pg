class ActivitiesController < ApplicationController

  def index
    if params[:status] && params[:client_id]
      @activities = Activity.where(client_id: params[:client_id],status: params[:status]).all
    elsif params[:client_id]
      @activities = Activity.where(client_id: params[:client_id]).all
    else
      @activities = Activity.all
    end

    if params[:project]
      @activities = @activities.select {|activity| activity["project"] == params[:project]}
    end
    if params[:format] == "csv"
      invoices_map = Invoice.map
      rows = Activity.all.to_a.map(&:serializable_hash)
      rows.each do |activity|
        if activity['invoice_id']
          activity['invoice_number'] = invoices_map[activity['invoice_id']]
        end
      end

      cols = { date:'date', client_name:'client name', project_id:'project', notes:'notes', hours:'hours', expense:'expense', status:'status', invoice_number:'invoice number'}
      @activities = rows.map{|activity| cols.keys.map{|col| activity[col.to_s]}}
      @activities.unshift cols.values
      render text: @activities.simple_csv
    else
      render :json => @activities
    end
  end

  def show
    @activity = Activity.find(params[:id])
    unless @activity
      render :json => { error: "activity not found: #{params[:id]}" }, :status => 404 and return
    end
    render :json => @activity.as_json(include: {project: {only: [:name]}})
  end

  def create
    client = Client.find(params["client_id"])
    @activity = client.activities.new(activity_params)
    if params["project"]
      @activity.project = client.find_or_create params["project"]
    end

    begin
      @activity.save
    rescue Exception => e
      status = 400
      if e.message.include? "Conflict"
        status = 409
      end
      render :json => { error: e.message, activity: @activity}, :status => status and return
    end

    render :json => @activity.as_json(include: {project: {only: [:name]}})
  end

  def update
    @activity = Activity.find(params[:id])
    if params["project"]
      @activity.project = @activity.client.find_or_create params['project']
    end
    unless @activity
      render :json => { error: "activity not found: #{params[:id]}" }, :status => 404 and return
    end
    @activity.attributes = activity_params
    if @activity.save
      render :json => @activity.as_json(include: {project: {only: [:name]}})
    else
      respond_with(@activity.errors, status: :unprocessable_entity)
    end
  end

  def destroy
    @activity = Activity.find(params[:id])
    unless @activity
      render :json => { error: "activity not found: #{params[:id]}" }, :status => 404 and return
    end
    unless @activity.status == 'Active'
      render :json => { error: "Only Active activities may be removed" }, :status => 400 and return
    end
    @activity.destroy
    render :json => { status: 'Deleted' }
  end

  private

  def activity_params
    params.require(:activity).permit(:notes, :date, :hours, :rate, :expense, :tax_rate, :tax_paid, :status)
  end

end
