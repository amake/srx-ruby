# frozen_string_literal: true

module Srx
  module Format
    # Support for plain text
    class Text < BaseFormat
      def extract_markups(str)
        [str, []]
      end
    end
  end
end
