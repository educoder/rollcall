require 'rest_client'
require 'uri'
require 'user'

EJABBERD_MOD_REST_URL = "http://proto.encorelab.org:5285/rest"

User.class_eval do
  before_create :create_account_in_openfire
  before_update :update_account_in_openfire
  before_destroy :delete_account_in_openfire
  
  def create_account_in_openfire
    command = %{register "#{self.username}" "proto.encorelab.org" "#{self.encrypted_password}"}
    ejabberd_rest_request(command)
  end

  def update_account_in_openfire
    command %{change_password "#{self.username}" "proto.encorelab.org" "#{self.encrypted_password}"}
    ejabberd_rest_request(command)
  end
  
  def delete_account_in_openfire
    command %{unregister "#{self.username}" "proto.encorelab.org"}
    ejabberd_rest_request(command)
  end

  private
  def ejabberd_rest_request(command)
    url = EJABBERD_MOD_REST_URL
    
    RestClient.log = Logger.new(STDOUT)
    response = RestClient.post(url, command)
    
    unless response =~ /<result>ok<\/result>/
      self.errors.add_to_base("Couldn't #{type} account in OpenFire!\n\n#{response.body}")
    end
    
    return response
  end
end