# frozen_string_literal: true

require 'test_helper'

module Srx
  module Format
    class XmlTest < Minitest::Test
      def test_tag_match
        assert(Xml::TAG.match?('<foo>'))
        assert(Xml::TAG.match?('<foo bar="baz">'))
        assert(Xml::TAG.match?("<foo bar='baz'>"))
        assert(Xml::TAG.match?('<foo bar="baz" >'))
        assert(Xml::TAG.match?('<foo bar="baz"/>'))
        assert(Xml::TAG.match?('</foo>'))

        refute(Xml::TAG.match?('< foo>'))
        refute(Xml::TAG.match?('<foo bar="<baz">'))
        refute(Xml::TAG.match?('<foo bar=baz>'))
        refute(Xml::TAG.match?('</foo bar="baz">'))
        refute(Xml::TAG.match?('</ foo>'))
      end

      def test_tag_scan
        text = 'foo <b>bar</b> <img alt="baz>"> bing <boing/>.'
        assert_equal(
          ['<b>', '</b>', '<img alt="baz>">', '<boing/>'],
          text.scan(Xml::TAG)
        )
      end

      def test_extract_markups
        sut = Xml.new
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
        sut = Xml.new
        assert(sut.start_formatting?('<foo>'))
        assert(sut.start_formatting?('<foo bar="baz">'))
        assert(sut.start_formatting?("<foo bar='baz'>"))

        refute(sut.start_formatting?('<foo bar=baz>'))
        refute(sut.start_formatting?('<foo bar>'))
        refute(sut.start_formatting?('</foo>'))
        refute(sut.start_formatting?('<foo/>'))
      end

      def test_end_formatting?
        sut = Xml.new
        assert(sut.end_formatting?('</foo>'))
        refute(sut.end_formatting?('<foo>'))
        refute(sut.end_formatting?('<foo/>'))
      end

      def test_isolated_formatting?
        sut = Xml.new
        assert(sut.isolated_formatting?('<foo/>'))
        assert(sut.isolated_formatting?('<foo bar="baz"/>'))
        assert(sut.isolated_formatting?("<foo bar='baz'/>"))

        refute(sut.isolated_formatting?('<foo bar=baz />'))
        refute(sut.isolated_formatting?('<foo bar />'))
        refute(sut.isolated_formatting?('<foo>'))
        refute(sut.isolated_formatting?('</foo>'))
      end
    end
  end
end
