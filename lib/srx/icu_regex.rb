# frozen_string_literal: true

module Srx
  # Utilities for handling SRX (ICU) regular expressions
  module IcuRegex
    HEX_PATTERN = /(?<!\\)(?:\\\\)*\\x(?<hex>[a-f0-9]{4}|\{[a-f0-9]{4}\})/i.freeze

    class << self
      # @param icu_regex [String]
      # @return [String]
      def to_ruby(icu_regex)
        icu_regex.gsub(HEX_PATTERN, '\u\k<hex>')
      end

      # @param icu_regex [String]
      # @return [Regexp]
      def compile(icu_regex)
        Regexp.new(to_ruby(icu_regex))
      end
    end
  end
end
