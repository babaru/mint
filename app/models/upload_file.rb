class UploadFile < ActiveRecord::Base
  include Mint::AttachmentAccessToken
  before_create :generate_access_token
  attr_accessible :attachment_access_token, :data_file
  has_attached_file :data_file,
    :path => ":rails_root/public:url",
    :url => "/system/upload_files/:attachment_access_token/file.:extension"
  serialize :meta_data, Hash
end
