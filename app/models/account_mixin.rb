module AccountMixin
  def self.included(target)
    target.class_eval do
      has_one :account, :autosave => true,
        :class_name => "#{self}Account", :as => :for,
        :dependent => :destroy
        
      # cannot change account once the User/Group/etc has been created
      attr_readonly :account
      
      delegate :login, :to => :account
      delegate :password, :to => :account
      delegate :encrypted_password, :to => :account
      
      accepts_nested_attributes_for :account,
        :reject_if => proc{|attributes| attributes['login'].blank? && attributes['password'].blank?},
        :allow_destroy => true, :update_only => true
        
      validates_associated :account,
        :message => "associated with this #{self.class} failed validation"
      
      after_validation do
        # fix weird error messages caused by :autosave => true combined with errors.full_messages
        if self.errors[:"account.base"]
          base_errors = self.errors[:base]
          if self.account
            account_base_errors = self.account.errors[:base]
            self.errors[:base].clear
            [base_errors + account_base_errors].each{|e| self.errors[:base] << e}
            self.errors.delete(:"account.base")
          end
        end
      end
      
    end
  end
end