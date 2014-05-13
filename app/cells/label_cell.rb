class LabelCell < Cell::Rails

  def show(args)
    @data = args[:data]
    render
  end

end
