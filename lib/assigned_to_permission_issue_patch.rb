require_dependency 'issue'

module AssignedToPermissionPlugin
  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      base.class_eval do
        validate :validate_presense_assigned_to,
          :if => lambda{ |o|
            !User.current.admin? && !User.current.allowed_to?(:edit_assigned_to, o.project)
          }
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def validate_presense_assigned_to
        if (self.new_record? && self.assigned_to.present?) || (!self.new_record? && Issue.find(self.id).assigned_to != self.assigned_to)
          errors.add :assigned_to, :no_permission
        end
      end
    end
  end
end
