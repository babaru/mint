class DropdownButtonCell < Cell::Rails

  def show(args)
    @button = args[:data]
    render
  end

end
