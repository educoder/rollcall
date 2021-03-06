class User < ActiveRecord::Base
  KINDS = ['Student', 'Instructor', 'Admin', 'Agent']
  
  has_many :group_memberships, :as => :member,
    :autosave => true, :dependent => :destroy
  has_many :groups, :through => :group_memberships
    
  validates_presence_of :kind
  validates_format_of :kind, :with => /^#{KINDS.join("|")}$/,
    :message => "must be #{KINDS.join(",")}"
  
  include MetadataAccessorMixin
  include AccountMixin
  
  validates :account, :presence => true
  
  validate do
    unless !account || account.valid?
      self.errors[:base] << "Account could not be #{account.new_record? ? "created" : "updated"}."
    end
    if account && account.allow_passwordless_login && is_admin?
      self.errors[:allow_passwordless_login] << "is not permitted for admin accounts."
    end
  end

  def to_s
    "#{display_name} (#{login})"
  end

  def username
    account.login
  end

  # stub to make openfire happy (openfire users need an email address)
  def email
    "#{login}@encorelab.org"
  end
  
  def is_admin?
    kind == 'Admin'
  end
  
  def self.find_by_login_or_id(name_or_id)
    if name_or_id =~ /^\d+/
      find(name_or_id)
    else
      find(:first, :conditions => {'accounts.login' => name_or_id}, :include => [:account, :groups]) or
        raise ActiveRecord::RecordNotFound, "#{self} #{name_or_id.inspect} doesn't exist!"
    end
  end

end
