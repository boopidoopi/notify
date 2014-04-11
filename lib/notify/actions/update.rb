module Notify
  module Update
    extend ActiveSupport::Concern
    included do
      after_update { create_notification :update }
    end
  end
end
