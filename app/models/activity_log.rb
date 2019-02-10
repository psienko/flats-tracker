class ActivityLog < ApplicationRecord
  TYPES = [
    :new_building_created,
    :new_flat_created,
    :flat_updated,
    :flat_status_changed,
    :building_creation_error,
    :flat_creation_error,
    :flat_update_error
  ]

  NEW_BUILDING_CREATED = :new_building_created
  NEW_FLAT_CREATED = :new_flat_created
  FLAT_UPDATED = :flat_updated
  FLAT_STATUS_CHANGED = :flat_status_changed
  BUILDING_CREATION_ERROR = :building_creation_error
  FLAT_CREATION_ERROR = :flat_creation_error

  belongs_to :activitable, polymorphic: true, optional: true

  delegate :provider, to: :activitable

  def humanized_provider
    provider.humanize.titleize
  end
end
