class User < ActiveRecord::Base
  KINDS = ['Student', 'Instructor', 'Admin']
  
  has_many :group_memberships, :as => :member,
    :autosave => true, :dependent => :destroy
  has_many :groups, :through => :group_memberships
  
  has_many :metadata, :as => :about, :autosave => true,
    :autosave => true, :dependent => :destroy
    
  validates_presence_of :kind
  validates_format_of :kind, :with => /^Student|Instructor|Admin$/,
    :message => "must be #{KINDS.join(",")}"
  
  include MetadataAccessorMixin
  include AccountMixin

  def to_s
    "#{display_name} (#{login})"
  end

  # stub to make openfire happy (openfire users need an email address)
  def email
    "#{login}@encorelab.org"
  end

end
