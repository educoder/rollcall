class ApplicationController < ActionController::Base
  #protect_from_forgery
  layout 'application'
  
  # use the custom responder from RestfulJSONP to handle
  # JSONP requests
  self.responder = RestfulJSONP::JSONPResponder
end
