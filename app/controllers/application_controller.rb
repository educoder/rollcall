class ApplicationController < ActionController::Base
  #protect_from_forgery
  layout 'application'
  session :on
  
  # use the custom responder from RestfulJSONP to handle
  # JSONP requests
  self.responder = RestfulJSONP::JSONPResponder
  
  protected
  def must_be_admin
    unless authenticated_as && User.find(authenticated_as).is_admin?
      redirect_to login_path(:destination => request.url), 
        :notice => "You must log in as an admin to access the requested area." #, :status => :unauthorized
    end
  end
  
  def authenticated_as
    session[:auth_session_id] && authenticated_session.account.for
  end
  helper_method :authenticated_as
  
  def authenticated_session
    session[:auth_session_id] && Session.find(session[:auth_session_id])
  end
  helper_method :authenticated_session
  
  def authenticate(sess)
    if sess.account.for.kind_of?(User)
      session[:auth_session_id] = sess.id
    else
      raise "Only users can authenticate for rollcall administration."
    end
  end
end
