class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  def versions
    if self.class == ImageUploader
      model.thumbnails.each_with_index do |t, i|
        t.name ||= "thumb#{i}"
        self.class.version(t.name) do
          process :resize_to_limit => [t.width, t.height]
        end
      end
    end
    super
  end
  
  version :thumb do
    process :resize_to_limit => [100, 100]
  end
end
