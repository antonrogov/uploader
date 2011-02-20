class Image
  include Mongoid::Document
  mount_uploader :image, ImageUploader, :delayed => true
  embeds_many :thumbnails
  accepts_nested_attributes_for :thumbnails, :reject_if => lambda {|attrs|
    %w[name width height].any? {|f| attrs[f].blank? }
  }
end
