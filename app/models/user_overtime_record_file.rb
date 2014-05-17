class UserOvertimeRecordFile < UploadFile
  validates_attachment_content_type :data_file, :content_type => %w(application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)

  def parse
    parser = ::Mint::ExcelParsers::UserOvertimeRecordFileParser.new data_file.path
    parser.parse
  end
end