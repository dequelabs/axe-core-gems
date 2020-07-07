require 'virtus'

module Axe
  module API
    class ValueObject
      include ::Virtus.value_object mass_assignment: false, nullify_blank: true
    end
  end
end
