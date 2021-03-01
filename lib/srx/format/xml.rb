# frozen_string_literal: true

require 'English'

module Srx
  module Format
    # Support for XML
    #
    # @see https://www.w3.org/TR/xml/
    class Xml < BaseFormat
      # rubocop:disable Layout/LineLength
      NAME_START_CHAR = /[:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\u{10000}-\u{EFFFF}]/.freeze
      # rubocop:enable Layout/LineLength
      NAME_CHAR = /#{NAME_START_CHAR}|[-.0-9\u00B7\u0300-\u036F\u203F-\u2040]/.freeze
      NAME = /#{NAME_START_CHAR}#{NAME_CHAR}*/.freeze
      SPACE = /[\u0020\u0009\u000D\u000A]+/.freeze
      EQUALS = /#{SPACE}?=#{SPACE}?/.freeze
      ENTITY_REF = /&#{NAME};/.freeze
      CHAR_REF = /&#[0-9]+;|&#x[0-9a-fA-F]+;/.freeze
      REFERENCE = /#{ENTITY_REF}|#{CHAR_REF}/.freeze
      ATT_VALUE = /"(?:[^<&"]|#{REFERENCE})*"|'(?:[^<&']|#{REFERENCE})*'/.freeze
      ATTRIBUTE = /#{NAME}#{EQUALS}#{ATT_VALUE}/.freeze
      START_TAG = /<#{NAME}(?:#{SPACE}#{ATTRIBUTE})*#{SPACE}?>/.freeze
      END_TAG = %r{</#{NAME}#{SPACE}?>}.freeze
      EMPTY_ELEM_TAG = %r{<#{NAME}(?:#{SPACE}#{ATTRIBUTE})*#{SPACE}?/>}.freeze

      TAG = /#{START_TAG}|#{END_TAG}|#{EMPTY_ELEM_TAG}/.freeze

      def extract_markups(str)
        extract_markups_by_pattern(str, TAG)
      end

      def start_formatting?(markup)
        START_TAG.match?(markup)
      end

      def end_formatting?(markup)
        END_TAG.match?(markup)
      end

      def isolated_formatting?(markup)
        EMPTY_ELEM_TAG.match?(markup)
      end

      protected

      # @param str [String]
      # @param pattern [Regexp]
      def extract_markups_by_pattern(str, pattern)
        markups = []

        plain_text = str.gsub(pattern) do |match|
          markups << [$LAST_MATCH_INFO.begin(0), match]
          ''
        end

        [plain_text, markups]
      end
    end
  end
end
