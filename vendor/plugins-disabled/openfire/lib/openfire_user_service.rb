module OpenfireUserService
  def create_account_in_openfire
    unless @openfire_account_created
      openfire_userservice_request('add',
        self.login,
        self.encrypted_password,
        "#{self.login}@openfire",
        self.login
      )
      @openfire_account_created = true unless @openfire_error
    end
  end

  def update_account_in_openfire
    unless @openfire_account_updated
      openfire_userservice_request('update',
        self.login,
        self.encrypted_password,
        "#{self.login}@openfire",
        self.login + " (#{id})"
      )
      @openfire_account_updated = true unless @openfire_error
    end
  end
  
  def delete_account_in_openfire
    openfire_userservice_request('delete',
      self.login
    )
  end
  
  def openfire_userservice_request(type, login, password = nil, email = nil, name = nil)
    url = "#{OPENFIRE_USERSERVICE_URL}?type=#{URI.escape(type)}" +
      "&secret=#{URI.escape(OPENFIRE_USERSERVICE_SECRET)}" +
      "&username=#{URI.escape(login)}&groups=rollcall"

    if type != 'delete'
      url << "&password=#{URI.escape(password)}" unless password.blank?
      url << "&name=#{URI.escape(name)}" unless name.blank?
      url << "&email=#{URI.escape(email)}" unless email.blank?
    end
    
    RestClient.log = Logger.new(STDOUT)
    
    begin
      response = RestClient.get(url)
      @openfire_error = nil
    rescue Errno::ECONNREFUSED => e
      response = "Connection refused to openfire server."
    end
    
    unless response =~ /<result>ok<\/result>/
      @openfire_error = response
    end
    
    return response
  end
end


