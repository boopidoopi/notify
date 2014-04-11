module Notify
  module Tracker
    extend ActiveSupport::Concern

    module ClassMethods
      def tracked(opts = {})
        actions = opts.fetch(:on, nil)
        return unless actions.present?

        self.notify_hooks = actions

        options = actions.clone
        include_modules(options)
      end

      def include_modules(options)
        modules = {
          :create => Creation,
          :update => Update,
          :destroy => Destruction
        }

        modules.select { |n, _| options.keys.include? n }.each do |_, m|
          include m
        end
      end
    end
  end
end
