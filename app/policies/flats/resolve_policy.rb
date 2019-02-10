module Flats
  class ResolvePolicy
    attr_reader :flat

    def initialize(flat)
      @flat = flat
    end

    def created?
      flat.id_previously_changed?
    end

    def no_changes?
      !created? && changes.blank?
    end

    def changed?
      !created? && changes.present?
    end

    def status_changed?
      changes.size == 1 && changes[:status].present?
    end

    private

    def changes
      flat.previous_changes.except(:created_at, :updated_at)
    end
  end
end
