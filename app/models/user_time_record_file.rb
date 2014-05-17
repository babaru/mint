class UserTimeRecordFile < UploadFile
  validates_attachment_content_type :data_file, :content_type => %w(application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)
  validates_attachment_presence :data_file
  attr_accessible :user_id, :user_name

  validates :user_id, presence: true

  def user_id
    meta_data[:user_id]
  end

  def user_id=(val)
    meta_data[:user_id] = val
  end

  def user_name
    meta_data[:user_name]
  end

  def user_name=(val)
    meta_data[:user_name] = val
  end

  def parse
    Rails.logger.debug data_file.path
    parser = ::Mint::ExcelParsers::UserTimeRecordFileParser.new data_file.path
    parser.parse
  end
end