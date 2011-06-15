class User < ActiveRecord::Base
  KINDS = ['Student', 'Instructor', 'Admin']
  
  has_many :group_memberships, :as => :member,
    :autosave => true, :dependent => :destroy
  has_many :groups, :through => :group_memberships
    
  validates_presence_of :kind
  validates_format_of :kind, :with => /^Student|Instructor|Admin$/,
    :message => "must be #{KINDS.join(",")}"
  
  include MetadataAccessorMixin
  include AccountMixin
  
  validates :account, :presence => true
  
  validate do
    unless !account || account.valid?
      self.errors[:base] << "Account could not be #{account.new_record? ? "created" : "updated"}."
    end
  end

  def to_s
    "#{display_name} (#{login})"
  end

  # stub to make openfire happy (openfire users need an email address)
  def email
    "#{login}@encorelab.org"
  end

end
