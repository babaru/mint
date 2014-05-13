class ButtonCell < Cell::Rails

  def show(args)
    @button = args[:data]
    @button[:options] = {} unless @button[:options]
    @button[:items] = [] unless @button[:items]

    if @button[:type] == 'split-dropdown'
      @button[:dropdown_options] = {}
      @button[:dropdown_options]['data-toggle'] = 'dropdown'
      @button[:dropdown_options][:class] = "#{@button[:options][:class]} dropdown-toggle"
    end

    if @button[:type] == 'dropdown'
      @button[:options]['data-toggle'] = 'dropdown'
      @button[:options][:class] = "#{@button[:options][:class]} dropdown-toggle"
    end

    render
  end

end
