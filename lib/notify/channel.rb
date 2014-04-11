module Notify
  module Channel
    extend ActiveSupport::Concern

    def create_channel(channel)
      listeners = self.subscriptions[channel] if self.subscriptions
      return unless listeners

      listeners.each do |l|
        # send model
        l.call(self)
      end
    end

    module ClassMethods
      def subscribe(channel, &block)
        listeners = self.subscriptions[channel]
        listeners ||= []
        listeners << block
        self.subscriptions[channel] = listeners
      end
    end
  end
end
