class DateTimePickerInput < SimpleForm::Inputs::Base
  def input
    content = []
    content << @builder.text_field(attribute_name, input_html_options)
    icon_content = template.content_tag(:i, nil, 'data-time-icon' => 'icon-time', 'data-date-icon' => 'icon-calendar')
    content << template.content_tag(:span, icon_content.html_safe, :class => 'add-on')
    template.content_tag(:div, content.join.html_safe, :class => 'date datetimepicker input-append date-time-picker')
  end
end
