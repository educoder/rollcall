module AccountMixin
  def self.included(target)
    target.class_eval do
      belongs_to :account, :autosave => true
      
      delegate :login, :to => :account
      delegate :password, :to => :account
      delegate :encrypted_password, :to => :account
      
      accepts_nested_attributes_for :account, :allow_destroy => true
      
      #validates :account, :presence => true
      
      validate do
        unless !account || account.valid?
          self.errors[:base] << "Account could not be #{account.new_record? ? "created" : "updated"}."
        end
      end
      
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