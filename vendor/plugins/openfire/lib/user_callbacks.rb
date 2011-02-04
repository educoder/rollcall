require 'net/http'
require 'uri'

OPENFIRE_USERSERVICE_URL = "http://proto.encorelab.org:9090/plugins/userService"
OPENFIRE_USERSERVICE_SECRET = "encore-s3-encore"
OPENFIRE_ROLLCALL_GROUP = "rollcall"

User.class_eval do
  after_create :create_account_in_openfire
  after_update :update_account_in_openfire
  after_destroy :delete_account_in_openfire
  
  def create_account_in_openfire
    openfire_userservice_request('add',
      self.username,
      self.password,
      self.email,
      self.display_name
    )
  end

  def update_account_in_openfire
    openfire_userservice_request('update',
      self.username,
      self.password,
      self.email,
      self.display_name
    )
  end
  
  def delete_account_in_openfire
    openfire_userservice_request('delete',
      self.username
    )
  end

  private
  def openfire_userservice_request(type, username, password = nil, email = nil, name = nil)
    url = "#{OPENFIRE_USERSERVICE_URL}/?type=#{type}" +
      "&secret=#{OPENFIRE_USERSERVICE_SECRET}" +
      "&username=#{username}&groups=rollcall"

    if type != 'delete'
      url << "&password=#{password}" unless password.blank?
      url << "&name=#{name}" unless name.blank?
      url << "&email=#{email}" unless email.blank?
    end
    
    Net::HTTP.get(URI.parse(url))
  end
end