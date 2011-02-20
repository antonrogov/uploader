class Thumbnail
  include Mongoid::Document
  
  field :name
  field :width, :type => Integer
  field :height, :type => Integer
  embedded_in :image
  
  validates_presence_of :name, :width, :height
end
