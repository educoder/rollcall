class SetupController < ApplicationController
  
  before_filter do |controller|
    if system_is_initialized?
      raise "This Rollcall system has already been initialized"
    end
  end
  
  def index
    if request.post?
      account = UserAccount.new(
        :login => params[:admin][:login], 
        :password => params[:admin][:password]
      )
      
      @admin = User.new(
        :display_name => params[:admin][:login],  
        :kind => "Admin", 
        :account => account)
      
      if @admin.save
        render :action => :complete
        return
      end
    else
      @admin = User.new(:account => UserAccount.new)
    end
    
    render :action => :setup
  end
  
end
