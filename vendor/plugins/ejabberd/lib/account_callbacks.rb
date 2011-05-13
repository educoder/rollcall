require 'rest_client'
require 'uri'
require 'account'

EJABBERD_MOD_REST_URL = "http://proto.encorelab.org:5285/rest"

Account.class_eval do
  unless Rails.env == 'test'
    include EjabberdRest
  
    before_validation :create_account_in_ejabberd, :on => :create
    before_validation :update_account_in_ejabberd, :on => :update
    before_destroy :delete_account_in_ejabberd
  
    validate do
      self.errors[:base] << @ejabberd_error if @ejabberd_error
    end
  end
end