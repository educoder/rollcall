class SetupController < ApplicationController
  
  before_filter do |controller|
    if system_is_initialized?
      raise "This Rollcall system has already been initialized"
    end
  end
  
  def index
    if request.post?
      # skip validations here to prevent plugins like rollcall-xmpp from crapping out
      account = UserAccount.create(
        :login => params[:admin][:login], 
        :password => params[:admin][:password],
        :validate => false)
      @admin = User.create(
        :display_name => params[:admin][:login],  
        :kind => "Admin", 
        :account => account)
      
      if @admin.valid?
        render :action => :complete
        return
      end
    else
      @admin = User.new(:account => UserAccount.new)
    end
    
    render :action => :setup
  end
  
end
