# frozen_string_literal: true

require_relative 'format/base_format'
require_relative 'format/text'
require_relative 'format/xml'

module Srx
  # Format-specific data and logic
  module Format
    FORMATS = {
      text: Text.new,
      xml: Xml.new,
      html: Xml.new # TODO: specialize for HTML
    }.freeze

    class << self
      # @param format [Symbol]
      # @return [BaseFormat]
      def get(format)
        raise(ArgumentError, "Unknown format: #{format}") unless FORMATS.key?(format)

        FORMATS[format]
      end
    end
  end
end
