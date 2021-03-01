# frozen_string_literal: true

require 'set'
require 'English'

module Srx
  module Format
    # Support for XML
    #
    # @see https://www.w3.org/TR/xml/
    class Html < Xml
      START_TAG = /<(?<name>#{Xml::NAME})(?:#{Xml::SPACE}#{ATTRIBUTE})*#{Xml::SPACE}?>/.freeze

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

      def start_formatting?(markup)
        START_TAG.match(markup) do |m|
          !VOID_ELEMENTS.include?(m['name'])
        end
      end

      def isolated_formatting?(markup)
        return true if super(markup)

        START_TAG.match(markup) do |m|
          VOID_ELEMENTS.include?(m['name'])
        end
      end
    end
  end
end
