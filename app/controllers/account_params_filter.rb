class AccountParamsFilter
  def self.filter(controller)
    resource = controller.params[:controller].singularize
    if controller.params[resource] && controller.params[resource][:account]
      controller.params[resource][:account_attributes] = controller.params[resource].delete(:account)
    end
  end
end