module Notify
  module Destruction
    extend ActiveSupport::Concern
    included do
      before_destroy { create_notification :destroy }
    end
  end
end
