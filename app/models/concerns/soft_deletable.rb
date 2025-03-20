module SoftDeletable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(deleted_at: nil) }
    scope :deleted, -> { where.not(deleted_at: nil) }
    default_scope { where(deleted_at: nil) }

    # Override the default destroy method to perform soft delete
    def destroy
      update(deleted_at: Time.current)
    end

    # Method to check if record is deleted
    def deleted?
      deleted_at.present?
    end

    # Method to permanently delete the record if needed
    def permanent_destroy
      super
    end

    # Method to restore a soft-deleted record
    def restore
      update(deleted_at: nil)
    end

    def really_destroy!
      super
    end
  end
end 