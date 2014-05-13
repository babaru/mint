class ButtonGroupCell < Cell::Rails

  def show(args)
    @buttons = args[:data]
    render
  end

end
