class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  before_action :set_js_class_name

  private
  def set_js_class_name
    action = case action_name
               when 'create' then 'New'
               when 'update' then 'Edit'
               else action_name
             end.camelize
    @js_class_name = "Controllers.#{self.class.name.gsub('::', '.').gsub(/Controller$/, '')}"
    @js_action_name = action
  end
end
