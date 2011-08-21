class PagesController < ApplicationController
  def index
    redirect_to project_path(1)
  end
  
  def admin
    @projects = [
      { :address_1 => '2317 Carnegie Lane', :address_2 => '', :city => 'Los Angeles', :state => 'CA', :zip => '90094' },
      { :address_1 => '246 Dafoe Blvd', :address_2 => '', :city => 'Los Angeles', :state => 'CA', :zip => '90094' },
      { :address_1 => '130 Catamaran St', :address_2 => '', :city => 'Los Angeles', :state => 'CA', :zip => '90094' },
      { :address_1 => '4141 Glencoe Ave', :address_2 => '', :city => 'Los Angeles', :state => 'CA', :zip => '90094' },
    ]
    respond_to do |wants|
      wants.html
      wants.js
    end
  end
  
  def project
    @project_id = params[:id]
    response = connection("projects/#{@project_id}/tasks").get
    @tasks = JSON.parse(response.body)
    @tasks = @tasks.collect do |task|
      t = { :date => Date.strptime(task['due-date']), :name => task['type-name'], :description => task['type-description'] }
      if task['type-id'] == 1
        t.merge!(:open => true)
        open_date = t[:date]
      end
      if task['type-id'] == 2
        t.merge!(:close => true)
        close_date = t[:date]
      end
    end
    raise open_date.inspect
    @dates = open_date..close_date
    
    respond_to do |wants|
      wants.html
      wants.js
    end
  end
  
  def login
    @person_id = params[:id]
  end
  
  def create_session
    @username = params[:login][:username]
    
    response = connection("people/#{@username}").get
    @person = JSON.parse(response.body).first
    if @person['permission-level'] == "Administrator"
      redirect_to admin_path
    else
      redirect_to project_path(1)
    end
  end
  
  def complete_task
    @task_id = params[:id]
    response = connection("tasks/#{@task_id}").put
    if response
      flash[:notice] = "Task updated"
    else
      flash[:error] = "Couldn't update task"
    end
  end
  
protected
  
  def connection(path)
    conn = Faraday.new(:url => 'http://ajax.escrowsnap.com/' + path) do |builder|
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
