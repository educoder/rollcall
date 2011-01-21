class Openfire::Base < ActiveRecord::Base
  self.abstract_class = true
  self.establish_connection :openfire
end