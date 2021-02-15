# frozen_string_literal: true

require_relative 'format/base_format'
require_relative 'format/text'
require_relative 'format/xml'
require_relative 'format/html'

module Srx
  # Format-specific data and logic
  module Format
    FORMATS = {
      text: Text.new,
      xml: Xml.new,
      html: Html.new
    }.freeze

    class << self
      # @param format [Symbol] see keys of {FORMATS} for accepted values
      # @return [BaseFormat]
      def get(format)
        raise(ArgumentError, "Unknown format: #{format}") unless FORMATS.key?(format)

        FORMATS[format]
      end
    end
  end
end
