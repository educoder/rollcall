class Metadata < ActiveRecord::Base
  belongs_to :about, :polymorphic => true
  
  before_validation :convert_key_and_value_to_string
  
  validates_length_of :key, :maximum => 255
  validates_length_of :value, :maximum => 255
  validates_uniqueness_of :key, :scope => :about_id
  
  def to_s
    "#{key} => #{value}"
  end
  
  private
  def convert_key_and_value_to_string
    self.key = self.key.to_s
    self.value = self.value.to_s
  end
  
end
