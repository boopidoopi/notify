module Notify
  module Creation
    extend ActiveSupport::Concern
    included do
      after_create { create_notification :create }
    end
  end
end
