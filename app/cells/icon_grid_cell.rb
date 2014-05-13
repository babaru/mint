class IconGridCell < Cell::Rails

  def show(args)
    @icon_grid = args[:data]
    render
  end

end
