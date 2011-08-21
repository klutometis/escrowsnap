class PagesController < ApplicationController
  def index
    redirect_to project_path(1)
  end
  
  def admin
    @username = 'mary'
    response = connection.get "/people/#{@username}/projects"
    @projects = JSON.parse(response.body)
    project_id = @projects.first['id']
    response = connection.get "/projects/#{project_id}/tasks"
    @tasks = JSON.parse(response.body)
    @tasks = @tasks.collect do |task|
      t = { :date => Date.strptime(task['due-date']), :name => task['type-name'], :description => task['type-description'] }
      t.merge!(:open => true) if task['type-id'] == 1#'Open Escrow'
      t.merge!(:close => true) if task['type-id'] == 2#'Close Escrow'
      t
    end
    respond_to do |wants|
      wants.html
      wants.js
    end
  end
  
  def project
    @project_id = params[:id]
    response = connection.get "/projects/#{@project_id}/tasks"
    @tasks = JSON.parse(response.body)
    open_date = nil
    close_date = nil
    @tasks = @tasks.collect do |task|
      t = { :date => Date.strptime(task['due-date']), :name => task['type-name'], :description => task['type-description'] }
      if task['type-id'] == 1#'Open Escrow'
        t.merge!(:open => true)
        open_date = t[:date]
      end
      if task['type-id'] == 2#'Close Escrow'
        t.merge!(:close => true)
        close_date = t[:date]
      end
      t
    end
    @dates = open_date..close_date
    
    respond_to do |wants|
      wants.html{ render :layout => 'project' }
      wants.js
    end
  end
  
  def login
    @person_id = params[:id]
  end
  
  def create_session
    @username = params[:login][:username]
    response = connection.get "/people/#{@username}"
    @person = JSON.parse(response.body).first
    if @person['permission-level'] == "Administrator"
      redirect_to admin_path
    else
      redirect_to project_path(1)
    end
  end
  
  def complete_task
    @task_id = params[:id]
    response = connection.get "/tasks/#{@task_id}&done=1"#, { :done => 1 }

    if response
      flash[:notice] = "Task updated"
    else
      flash[:error] = "Couldn't update task"
    end
  end
  
  def uncomplete_task
    @task_id = params[:id]
    response = connection.get "/tasks/#{@task_id}&done=0"#, { :done => 0 }
    if response
      flash[:notice] = "Task updated"
    else
      flash[:error] = "Couldn't update task"
    end
  end
  
protected
  
  def connection
    conn = Faraday.new(:url => 'http://ajax.escrowsnap.com') do |builder|
      builder.use Faraday::Request::UrlEncoded  # convert request params as "www-form-urlencoded"
      builder.use Faraday::Request::JSON        # encode request params as json
      builder.use Faraday::Response::Logger     # log the request to STDOUT
      builder.use Faraday::Adapter::NetHttp     # make http requests with Net::HTTP

      # or, use shortcuts:
      builder.request  :url_encoded
      builder.request  :json
      builder.response :logger
      builder.adapter  :net_http
    end
  end

end
