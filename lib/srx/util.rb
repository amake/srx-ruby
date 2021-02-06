# frozen_string_literal: true

module Srx
  # Miscellaneous utility functions
  module Util
    class << self
      # Remove linebreaks that wrap lines.
      #
      # @param str [String]
      # @return [String]
      def unwrap(str)
        str.gsub(/(?<=\S)\n(?=\S)/, ' ')
      end
    end
  end
end
