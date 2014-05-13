module Tida
  module Renderers
    module ComponentRenderer
      def render_component(options = {})
        render partial: options[:partial], object: options
      end

      def render_page_title(title)
        toolbar = []
        if block_given?
          yield toolbar
        end
        data = {title: title.html_safe, toolbar: toolbar, partial: 'shared/components/page_title'}
        render_component data
      end

      def render_article_title(title, class_name = nil)
        toolbar = []
        if block_given?
          yield toolbar
        end
        data = {title: title.html_safe, class: class_name, toolbar: toolbar, partial: 'shared/components/article_title'}
        render_component data
      end

      def render_modal_window(options = {})
        options = options.merge({partial: 'shared/components/modal'})
        render_component options
      end

      def render_icon_and_text_content(icon_name, text)
        content = []
        content << content_tag(:i, nil, class: icon_name)
        content << content_tag(:span, text)
        content.join(" ").html_safe
      end

      def icon(name)
        content_tag(:i, nil, class: name)
      end

      def icon_text(icon_name, text)
        content = []
        content << content_tag(:i, nil, class: icon_name)
        content << content_tag(:span, text)
        content.join(" ").html_safe
      end

      def render_icon_content(icon_name)
        content_tag(:i, nil, class: icon_name)
      end

      def render_progress_bar(label)
        label_content = content_tag :span, label
        bar_content = content_tag :div, label_content, class: 'bar', style: 'width: 100%;'
        content_tag :div, bar_content, class: 'progress progress-striped active'
      end
    end
  end
end
