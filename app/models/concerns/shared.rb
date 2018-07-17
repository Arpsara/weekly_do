module Shared
  extend ActiveSupport::Concern
  included do
    scope :visible, -> { where(deleted: false) }
  end
end
