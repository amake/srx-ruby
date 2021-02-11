# frozen_string_literal: true

module Srx
  # Utilities for handling markup.
  #
  # @see https://www.w3.org/TR/xml/
  module Markup
    NAME_START_CHAR = /:|[A-Z]|_|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|
                       [\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|
                       [\uF900-\uFDCF]|[\uFDF0-\uFFFD]|[\u{10000}-\u{EFFFF}]/x.freeze
    NAME_CHAR = /#{NAME_START_CHAR}|-|\.|[0-9]|\u00B7|[\u0300-\u036F]|[\u203F-\u2040]/.freeze
    NAME = /#{NAME_START_CHAR}#{NAME_CHAR}*/.freeze
    SPACE = /(?:\u0020|\u0009|\u000D|\u000A)+/.freeze
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
  end
end
