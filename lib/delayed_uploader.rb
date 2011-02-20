module CarrierWave
  module Mount
    class Mounter
      def cache_with_delay(new_file)
        if option(:delayed)
          uploader.cache_with_delay!(new_file)
        else
          cache_without_delay
        end
      end
      alias_method_chain :cache, :delay
      
      def store!
        unless uploader.blank?
          if remove?
            uploader.remove!
          elsif option(:delayed)
            uploader.store_with_delay!
          else
            uploader.store!
          end
        end
      end
    end
  end
  
  module Uploader
    class Base
      def cache_with_delay!(new_file)
        new_file = CarrierWave::SanitizedFile.new(new_file)
        raise CarrierWave::FormNotMultipart if new_file.is_path? && ensure_multipart_form

        unless new_file.empty?
          self.cache_id = CarrierWave.generate_cache_id unless cache_id
          self.original_filename = new_file.filename
          @file = new_file.copy_to(cache_path, permissions)
        end
      end

      def store_with_delay!(enqueue = true)
        if enqueue
          delay.store_with_delay!(false) unless cache_name.blank?
        else
          file = CarrierWave::SanitizedFile.new(cache_path)
          store!(file)
          
          column = model.class.uploader_option(mounted_as, :mount_on) || mounted_as
          model.write_uploader(column, identifier)
          model.save
        end
      end
    end
  end
end
