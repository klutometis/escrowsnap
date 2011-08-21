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

    conn = Faraday.new(:url => 'http://localhost/scm/escrowsnap-server/tasks/' + @project_id) do |builder|
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

    response = conn.get
    @tasks = JSON.parse(response.body)
    
    @tasks = [
      { :date => Date.today, :name => 'Open Escrow', :description => "Donec semper quam scelerisque tortor dictum gravida. In hac habitasse platea dictumst. Nam pulvinar, odio sed rhoncus suscipit, sem diam ultrices mauris, eu consequat purus metus eu velit. Proin metus odio, aliquam eget molestie nec, gravida ut sapien. Phasellus quis est sed turpis sollicitudin venenatis sed eu odio. Praesent eget neque eu eros interdum malesuada non vel leo. Sed fringilla porta ligula." },
      { :date => Date.today + 4.days, :name => 'Appraisal', :description => 'Donec semper quam scelerisque tortor dictum gravida. In hac habitasse platea dictumst. Nam pulvinar, odio sed rhoncus suscipit, sem diam ultrices mauris, eu consequat purus metus eu velit. Proin metus odio, aliquam eget molestie nec, gravida ut sapien. Phasellus quis est sed turpis sollicitudin venenatis sed eu odio. Praesent eget neque eu eros interdum malesuada non vel leo. Sed fringilla porta ligula.' },
      { :date => Date.today + 8.days, :name => 'Inspection', :description => 'Donec semper quam scelerisque tortor dictum gravida. In hac habitasse platea dictumst. Nam pulvinar, odio sed rhoncus suscipit, sem diam ultrices mauris, eu consequat purus metus eu velit. Proin metus odio, aliquam eget molestie nec, gravida ut sapien. Phasellus quis est sed turpis sollicitudin venenatis sed eu odio. Praesent eget neque eu eros interdum malesuada non vel leo. Sed fringilla porta ligula.', :active => true },
      { :date => Date.today + 15.days, :name => 'Insurance', :description => 'Donec semper quam scelerisque tortor dictum gravida. In hac habitasse platea dictumst. Nam pulvinar, odio sed rhoncus suscipit, sem diam ultrices mauris, eu consequat purus metus eu velit. Proin metus odio, aliquam eget molestie nec, gravida ut sapien. Phasellus quis est sed turpis sollicitudin venenatis sed eu odio. Praesent eget neque eu eros interdum malesuada non vel leo. Sed fringilla porta ligula.' },
      { :date => Date.today + 21.days, :name => 'Loan', :description => 'Donec semper quam scelerisque tortor dictum gravida. In hac habitasse platea dictumst. Nam pulvinar, odio sed rhoncus suscipit, sem diam ultrices mauris, eu consequat purus metus eu velit. Proin metus odio, aliquam eget molestie nec, gravida ut sapien. Phasellus quis est sed turpis sollicitudin venenatis sed eu odio. Praesent eget neque eu eros interdum malesuada non vel leo. Sed fringilla porta ligula.' },
      { :date => Date.today + 29.days, :name => 'Close Escrow', :description => 'Donec semper quam scelerisque tortor dictum gravida. In hac habitasse platea dictumst. Nam pulvinar, odio sed rhoncus suscipit, sem diam ultrices mauris, eu consequat purus metus eu velit. Proin metus odio, aliquam eget molestie nec, gravida ut sapien. Phasellus quis est sed turpis sollicitudin venenatis sed eu odio. Praesent eget neque eu eros interdum malesuada non vel leo. Sed fringilla porta ligula.' }
    ]
    
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
    
    # Faraday
    @person = {
      'permission-level' => 0
    }
    
    if @person['permission-level'] == 1
      redirect_to admin_path
    else
      redirect_to project_path(1)
    end
  end
end
