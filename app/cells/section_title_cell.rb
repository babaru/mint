class SectionTitleCell < Cell::Rails

  def show(args)
    @section_title = args[:data]
    render
  end

end
