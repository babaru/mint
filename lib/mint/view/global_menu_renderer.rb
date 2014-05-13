module Mint
  module View
    class GlobalMenuRenderer < ::SimpleNavigation::Renderer::Base
      include ::FontAwesome::Rails::IconHelper

      def render(item_container)
        list_content = item_container.items.inject([]) do |list, item|
          list << item_content(item, top: true)
        end.join
        content_tag(:ul, list_content, class: "nav")
      end

      protected

      def item_content(item, opt = {})
        return sub_menu(item, opt) if include_sub_navigation?(item)
        tag_for(item, opt)
      end

      def tag_for(item, opt = {})
        options = options_for(item)
        options = options.merge(opt)
        divider = options.delete(:divider)
        return content_tag(:li, nil, class: 'divider') if divider

        content_tag(:li, a_tag_for(item, options))
      end

      def a_tag_for(item, options)
        icon = options.delete(:icon)
        stack_icon = options.delete(:stack_icon)
        icon_content = fa_icon(icon) if icon
        icon_content = fa_stack_icon(stack_icon[:icon], base: stack_icon[:base]) if stack_icon
        top_level = options.delete(:top)

        link_to([
            icon_content,
            (options['data-toggle'] ? [item.name, top_level ? fa_icon('angle-down') : fa_icon('angle-right')].join(' ') : item.name),
          ].join(' ').html_safe,
          item.url,
          options
          )
      end

      def sub_menu(item, opt = {})
        options = options_for(item)
        options = options.merge(opt)
        options[:class] = [] unless options[:class]
        options[:class] << ' dropdown-toggle'
        options['data-toggle'] = 'dropdown'
        content = []

        content_tag(:li, [
          a_tag_for(item, options),
          sub_menu_content(item)
          ].join,
          class: 'dropdown'
        )
      end

      def sub_menu_content(item)
        content = item.sub_navigation.items.inject([]) do |list, sub_item|
          list << item_content(sub_item)
        end.join
        content_tag(:ul, content, class: 'dropdown-menu')
      end
    end
  end
end
