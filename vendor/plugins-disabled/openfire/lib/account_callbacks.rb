require 'rest_client'
require 'uri'
require 'account'

OPENFIRE_USERSERVICE_URL = "http://proto.encorelab.org:9090/plugins/accountService/userservice"
OPENFIRE_USERSERVICE_SECRET = "encores3encore"
OPENFIRE_ROLLCALL_GROUP = "rollcall"

Account.class_eval do
  include OpenfireUserService
  
  before_validation :create_account_in_openfire, :on => :create
  before_validation :update_account_in_openfire, :on => :update
  before_destroy :delete_account_in_openfire
  
  validate do
    self.errors[:base] << @openfire_error if @openfire_error
  end
end