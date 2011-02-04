class User < ActiveRecord::Base
  KINDS = ['Student', 'Instructor', 'Admin']
  
  # can't change username after creation because this acts
  # as a link to the corresponding OpenFire account
  attr_readonly :username
  
  has_many :sessions,
    :dependent => :destroy
  
  has_many :group_memberships, :as => :member,
    :autosave => true, :dependent => :destroy
  has_many :groups, :through => :group_memberships
  
  has_many :metadata, :as => :about, :autosave => true,
    :autosave => true, :dependent => :destroy
    
  validates_presence_of :username, :kind
  validates_format_of :kind, :with => /^Student|Instructor|Admin$/,
    :message => "must be 'Student', 'Instructor', or 'Admin'"
  
  include MetadataAccessorMixin

  def to_s
    "#{display_name} (#{username})"
  end

  # stub to make openfire happy (openfire users need an email address)
  def email
    "#{username}@encorelab.org"
  end


end
