class PageTitleCell < Cell::Rails

  def show(args)
    @page_title = args[:data]

    render
  end

end
