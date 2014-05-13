class ModalWindowCell < Cell::Rails

  def show(args)
    @modal_window = args[:data]
    render
  end

end
