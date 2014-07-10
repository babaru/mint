# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items.
  # Defaults to 'selected'
  navigation.selected_class = 'active'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  navigation.active_leaf_class = 'nil'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that
  # will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name, item| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # If this option is set to true, all item names will be considered as safe (passed through html_safe). Defaults to false.
  # navigation.consider_item_names_as_safe = false

  # Define the primary navigation
  navigation.items do |primary|
    primary.item(
      :page_dashboard,
      t('navigation.page_dashboard'),
      dashboard_path,
      {
        link:
        {
          icon: 'dashboard'
        },
        highlights_on: /dashboard/
      }
    )

    primary.item(
      :page_clients,
      t('navigation.page_clients'),
      clients_path,
      {
        link:
        {
          icon: 'male'
        },
        highlights_on: /clients/
      }
    ) do |clients_menu|

      clients_menu.item(
        :page_clients,
        t('navigation.page_clients'),
        clients_path,
        {
          link:
          {
            icon: 'list'
          }
        }
      )

      clients_menu.item(
        :page_client_time_report,
        t('navigation.page_client_time_report'),
        time_report_path(kind: :client),
        {
          link:
          {
            icon: 'file'
          }
        }
      )

    end

    primary.item(
      :page_projects,
      t('navigation.page_projects'),
      projects_path,
      {
        link:
        {
          icon: 'briefcase'
        },
        highlights_on: /projects/
      }
    ) do |projects_menu|

      projects_menu.item(
        :page_projects,
        t('navigation.page_projects'),
        projects_path,
        {
          link:
          {
            icon: 'list'
          }
        }
      )

      projects_menu.item(
        :page_project_time_report,
        t('navigation.page_project_time_report'),
        time_report_path(kind: :project),
        {
          link:
          {
            icon: 'file'
          }
        }
      )

    end

    primary.item(
      :page_users,
      t('navigation.page_users'),
      nil,
      {
        link:
        {
          icon: 'briefcase'
        },
        highlights_on: /users/
      }
    ) do |users_menu|

      users_menu.item(
        :page_user_time_report,
        t('navigation.page_user_time_report'),
        time_report_path(kind: :user),
        {
          link:
          {
            icon: 'file'
          }
        }
      )

    end

    primary.item(
      :page_operation,
      t('navigation.page_operation'),
      nil,
      {
        link:
        {
          icon: 'cog'
        }
      }
    ) do |operation_menu|

      operation_menu.item(
        :page_time_sheets,
        t('navigation.page_calculate_time_sheets'),
        calculate_time_sheets_path,
        {
          link:
          {
            icon: 'cogs'
          }
        }
      )

      operation_menu.item(
        :page_time_divider_2,
        nil, nil,
        {
          link:
          {
            divider: true
          }
        }
      )

      operation_menu.item(
        :page_upload_time_records,
        t('model.upload', :model => TimeRecord.model_name.human),
        upload_time_records_path,
        {
          link:
          {
            icon: 'cloud-upload'
          }
        }
      )

      operation_menu.item(
        :page_upload_overtime_records,
        t('model.upload', :model => OvertimeRecord.model_name.human),
        upload_overtime_records_path,
        {
          link:
          {
            icon: 'cloud-upload'
          }
        }
      )

    end

    primary.item(
      :page_configuration,
      t('navigation.page_configuration'),
      nil,
      {
        link:
        {
          icon: 'puzzle-piece'
        },
        highlights_on: /config/
      }
    ) do |configuration_menu|

      configuration_menu.item(
        :page_users,
        t('navigation.page_users'),
        users_path,
        {
          link:
          {
            icon: 'group'
          }
        }
      )

      configuration_menu.item(
        :page_roles,
        t('navigation.page_roles'),
        roles_path,
        {
          link:
          {
            icon: 'tag'
          }
        }
      )

    end
  end
end
