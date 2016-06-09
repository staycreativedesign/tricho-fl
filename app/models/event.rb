class Event < ActiveRecord::Base
  mount_uploader :small_image, EventSmallImageUploader
  mount_uploader :image, EventImageUploader
end
