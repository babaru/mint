<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  # GET <%= route_url %>
  # GET <%= route_url %>.json
  def index
    @<%= class_name.split('::').last.underscore.downcase.pluralize %>_grid = initialize_grid(<%= class_name.split('::').last %>)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: <%= "@#{class_name.split('::').last.underscore.downcase.pluralize}_grid" %> }
    end
  end

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.json
  def show
    @<%= class_name.split('::').last.underscore.downcase %> = <%= orm_class.find(class_name.split('::').last, "params[:id]") %>

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: <%= "@#{class_name.split('::').last.underscore.downcase}" %> }
    end
  end

  # GET <%= route_url %>/new
  # GET <%= route_url %>/new.json
  def new
    @<%= class_name.split('::').last.underscore.downcase %> = <%= orm_class.build(class_name.split('::').last) %>

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: <%= "@#{class_name.split('::').last.underscore.downcase}" %> }
    end
  end

  # GET <%= route_url %>/1/edit
  def edit
    @<%= class_name.split('::').last.underscore.downcase %> = <%= orm_class.find(class_name.split('::').last, "params[:id]") %>
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.json
  def create
    @<%= class_name.split('::').last.underscore.downcase %> = <%= orm_class.build(class_name.split('::').last, "params[:#{class_name.split('::').last.underscore.downcase}]") %>

    respond_to do |format|
      if @<%= class_name.split('::').last.underscore.downcase %>.save
        format.html { redirect_to <%= class_name.split('::').last.underscore.downcase.pluralize %>_path, notice: <%= "'#{human_name} was successfully created.'" %> }
        format.json { render json: <%= "@#{class_name.split('::').last.underscore.downcase}" %>, status: :created, location: <%= "@#{class_name.split('::').last.underscore.downcase}" %> }
      else
        format.html { render action: "new" }
        format.json { render json: <%= "@#{class_name.split('::').last.underscore.downcase}.errors" %>, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT <%= route_url %>/1
  # PATCH/PUT <%= route_url %>/1.json
  def update
    @<%= class_name.split('::').last.underscore.downcase %> = <%= orm_class.find(class_name.split('::').last, "params[:id]") %>

    respond_to do |format|
      if @<%= class_name.split('::').last.underscore.downcase %>.update_attributes(params[:<%= class_name.split('::').last.underscore.downcase %>])
        format.html { redirect_to <%= class_name.split('::').last.underscore.downcase.pluralize %>_path, notice: <%= "'#{human_name} was successfully updated.'" %> }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: <%= "@#{class_name.split('::').last.underscore.downcase}.errors" %>, status: :unprocessable_entity }
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.json
  def destroy
    @<%= class_name.split('::').last.underscore.downcase %> = <%= orm_class.find(class_name.split('::').last, "params[:id]") %>
    @<%= class_name.split('::').last.underscore.downcase %>.destroy

    respond_to do |format|
      format.html { redirect_to <%= index_helper %>_url }
      format.json { head :no_content }
    end
  end
end
<% end -%>
