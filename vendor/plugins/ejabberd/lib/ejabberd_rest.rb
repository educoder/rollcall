module EjabberdRest
  def create_account_in_ejabberd
    unless @ejabberd_account_created
      command = %{register "#{self.login}" "proto.encorelab.org" "#{self.encrypted_password}"}
      ejabberd_rest_request(command)
      @ejabberd_account_created = true unless @ejabberd_error
    end
  end

  def update_account_in_ejabberd
    unless @ejabberd_account_created
      command = %{change_password "#{self.login}" "proto.encorelab.org" "#{self.encrypted_password}"}
      ejabberd_rest_request(command)
      @ejabberd_account_created = true unless @ejabberd_error
    end
  end
  
  def delete_account_in_ejabberd
    command = %{unregister "#{self.login}" "proto.encorelab.org"}
    ejabberd_rest_request(command)
  end

  def ejabberd_rest_request(command)
    url = EJABBERD_MOD_REST_URL
    
    RestClient.log = Logger.new(STDOUT)
    begin
      response = RestClient.post(url, command)
      @jabberd_error = nil
    rescue RestClient::InternalServerError => e # TODO: deal with other possible errors
      @ejabberd_error = "Ejabberd command `#{command}` resulted in error:\n#{e}"
      response = e
    rescue RestClient::NotAcceptable => e
      @ejabberd_error = "Ejabberd REST service refused to execute the command:\n#{command} (make sure that ejabberd's mod_rest is configured to allow connections from Rollcall's IP)"
      response = e
    end
    
    return response
  end
end