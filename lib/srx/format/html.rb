# frozen_string_literal: true

require 'set'
require 'English'

module Srx
  module Format
    # Support for HTML. Tag grammar based on XML.
    #
    # @see https://www.w3.org/TR/xml/
    # @see https://html.spec.whatwg.org/multipage/syntax.html
    class Html < Xml
      # Differs from XML in supporting unquoted values
      # @see https://html.spec.whatwg.org/multipage/syntax.html#attributes-2
      ATT_VALUE = /#{Xml::ATT_VALUE}|(?:[^<>&"'`=\u0020\u0009\u000D\u000A]|#{Xml::REFERENCE})+/.freeze

      # Differs from XML in supporting empty attributes
      # @see https://html.spec.whatwg.org/multipage/syntax.html#attributes-2
      ATTRIBUTE = /#{Xml::NAME}(?:#{Xml::EQUALS}#{ATT_VALUE})?/.freeze

      START_TAG = /<(?<name>#{Xml::NAME})(?:#{Xml::SPACE}#{ATTRIBUTE})*#{Xml::SPACE}?>/.freeze
      EMPTY_ELEM_TAG = %r{<#{Xml::NAME}(?:#{Xml::SPACE}#{ATTRIBUTE})*#{Xml::SPACE}?/>}.freeze

      TAG = /#{START_TAG}|#{Xml::END_TAG}|#{EMPTY_ELEM_TAG}/.freeze

      # A set of HTML tags that are "void elements", meaning they do not need a
      # paired closing tag.
      #
      # @see https://html.spec.whatwg.org/#void-elements
      # @see https://developer.mozilla.org/en-US/docs/Web/HTML/Element/command
      # @see https://developer.mozilla.org/en-US/docs/Web/HTML/Element/keygen
      # @see https://developer.mozilla.org/en-US/docs/Web/HTML/Element/menuitem
      VOID_ELEMENTS = Set[
        'area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'input',
        'link', 'meta', 'menuitem', 'param', 'source', 'track', 'wbr'
      ].freeze

      def extract_markups(str)
        extract_markups_by_pattern(str, TAG)
      end

      def start_formatting?(markup)
        !!START_TAG.match(markup) do |m|
          !VOID_ELEMENTS.include?(m['name'])
        end
      end

      def isolated_formatting?(markup)
        return true if EMPTY_ELEM_TAG.match?(markup)

        START_TAG.match(markup) do |m|
          VOID_ELEMENTS.include?(m['name'])
        end
      end
    end
  end
end
