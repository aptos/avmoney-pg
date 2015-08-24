class ClientsController < ApplicationController

  def index
    if params[:active]
      @clients = Client.where(archived: false).order(name: :asc)
    else
      @clients = Client.all.order(name: :asc)
    end
    render :json => @clients
  end

  def show
    @client = Client.find(params[:id])
    render :json => @client
  end

  def create
    @client = Client.new(client_params)
    begin
      @client.save!
    rescue Exception => e
      status = 400
      if e.message.include? "Conflict"
        status = 409
      end
      render :json => { error: e.message, client: @client }, :status => status and return
    end
    render :json => @client
  end

  def update
    @client = Client.find(params[:id])
    unless @client
      render :json => { error: "client not found: #{params[:id]}" }, :status => 404 and return
    end
    @client.attributes = client_params
    if @client.save!
      render :json => @client
    else
      respond_with(@client.errors, status: :unprocessable_entity)
    end
  end

  def activities
    render :json => @activities
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    render :json => { status: 'Deleted' }
  end

  def projects
    @projects = Client.find(params[:id]).projects.all
    render :json => @projects
  end

  def projects_report
    @projects = Client.find(params[:id]).projects.all.to_a.map(&:serializable_hash)
    @projects.each do |project|
      project['activities'] = Activity.project_summary params[:id], project['id']
    end
    if params[:format] == "csv"
      report = @projects.map{|p| [p['wo_number'], p['name'], p['cap'], p['activities'][:total]]}
      report.unshift ['work order', 'name', 'cap', 'total']
      render text: report.simple_csv
    else
      render :json => @projects
    end

  end

  def update_project
    project_params['wo_number'] || project_params['wo_number'] = nil
    project_params['po_number'] || project_params['po_number'] = nil
    project_params['cap'] || params['cap'] = 0
    if params[:project][:id]
      @project = Project.find(params[:project][:id])
      unless @project
        render :json => { error: "project not found: #{params[:project][:id]}" }, :status => 404 and return
      end
      @project.update_attributes(project_params)
    else
      @project = Project.create({
        client_id: params[:id],
        name: project_params[:name],
        wo_number: project_params[:wo_number],
        po_number: project_params[:po_number],
        cap: project_params[:cap]
        })
    end
    render :json => @project
  end

  def next_invoice
    @client = Client.find(params[:id])
    unless @client
      render :json => { error: "client not found: #{params[:id]}" }, :status => 404 and return
    end
    render :json => @client.next_invoice
  end

  private

  def client_params
    params.require(:client).permit(:name,:rate,:tax_rate,:address,:deliveries,:contact,:email,:phone,:cell,:contact2,:email2,:phone2,:cell2,:base_invoice_id,:archived, :activities)
  end

  def project_params
    params.require(:project).permit(:id, :client_id, :project_id, :name, :wo_number, :po_number, :cap)
  end

end
