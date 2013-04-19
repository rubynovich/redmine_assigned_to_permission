require 'redmine'

Redmine::Plugin.register :redmine_assigned_to_permission do
  name 'Redmine Assigned To Permission plugin'
  author 'Roman Shipiev'
  description 'Plugin add permission for assigned_to-field'
  version '0.0.1'
  url 'https://github.com/rubynovich/redmine_assigned_to_permission'
  author_url 'http://roman.shipiev.me'
end

if Rails::VERSION::MAJOR < 3
  require 'dispatcher'
  object_to_prepare = Dispatcher
else
  object_to_prepare = Rails.configuration
end

object_to_prepare.to_prepare do
  [:issue].each do |cl|
    require "assigned_to_permission_#{cl}_patch"
  end

  [
    [Issue, AssignedToPermissionPlugin::IssuePatch],
  ].each do |cl, patch|
    cl.send(:include, patch) unless cl.included_modules.include? patch
  end
end
