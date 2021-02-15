# frozen_string_literal: true

module Srx
  # Utilities for handling SRX (ICU) regular expressions
  module IcuRegex
    HEX_PATTERN = /(?<!\\)(?:\\\\)*\\x(?<hex>\{[a-f0-9]{1,6}\})/i.freeze
    OCTAL_PATTERN = /(?<!\\)(?:\\\\)*\\0(?<oct>[0-7]{1,3})/i.freeze

    class << self
      # @param icu_regex [String]
      # @return [String]
      def to_ruby(icu_regex)
        result = icu_regex.dup
        result.gsub!(HEX_PATTERN, '\u\k<hex>')
        result.gsub!(OCTAL_PATTERN) do |m|
          $LAST_MATCH_INFO['oct'].to_i(8).then { |o| o <= 255 ? format(%q(\u{%x}), o) : m }
        end

        result
      end

      # @param icu_regex [String]
      # @return [Regexp]
      def compile(icu_regex)
        Regexp.new(to_ruby(icu_regex))
      end
    end
  end
end
