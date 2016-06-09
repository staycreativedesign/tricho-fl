class Team < ActiveRecord::Base
  mount_uploader :image, ImageUploader
end
