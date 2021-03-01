# frozen_string_literal: true

require 'test_helper'

module Srx
  module Format
    class HtmlTest < Minitest::Test
      def test_extract_markups
        sut = Html.new
        text = 'foo <b>bar</b> <img alt="baz>"> bing <boing/>.'
        plain_text, markups = sut.extract_markups(text)
        assert_equal('foo bar  bing .', plain_text)
        assert_equal(
          [
            [4, '<b>'],
            [10, '</b>'],
            [15, '<img alt="baz>">'],
            [37, '<boing/>']
          ],
          markups
        )
      end

      def test_start_formatting?
        sut = Html.new
        assert(sut.start_formatting?('<foo>'))
        assert(sut.start_formatting?('<foo bar="baz">'))
        assert(sut.start_formatting?("<foo bar='baz'>"))
        assert(sut.start_formatting?('<foo bar=baz>'))
        assert(sut.start_formatting?('<foo bar>'))

        refute(sut.start_formatting?('</foo>'))
        refute(sut.start_formatting?('<foo/>'))

        # Void element
        refute(sut.start_formatting?('<img>'))
      end

      def test_end_formatting?
        sut = Html.new
        assert(sut.end_formatting?('</foo>'))
        refute(sut.end_formatting?('<foo>'))
        refute(sut.end_formatting?('<foo/>'))
      end

      def test_isolated_formatting?
        sut = Html.new
        assert(sut.isolated_formatting?('<foo/>'))
        assert(sut.isolated_formatting?('<foo bar="baz"/>'))
        assert(sut.isolated_formatting?("<foo bar='baz'/>"))
        assert(sut.isolated_formatting?('<foo bar=baz />'))
        assert(sut.isolated_formatting?('<foo bar />'))

        refute(sut.isolated_formatting?('<foo>'))
        refute(sut.isolated_formatting?('</foo>'))

        # Void element
        assert(sut.isolated_formatting?('<img>'))
      end
    end
  end
end
