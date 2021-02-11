# frozen_string_literal: true

require 'test_helper'

# srx/markup not loaded unless needed, so we need to manually require it here.
require 'srx/markup'

module Srx
  class MarkupTest < Minitest::Test
    def test_tag_match
      assert(Markup::TAG.match?('<foo>'))
      assert(Markup::TAG.match?('<foo bar="baz">'))
      assert(Markup::TAG.match?("<foo bar='baz'>"))
      assert(Markup::TAG.match?('<foo bar="baz" >'))
      assert(Markup::TAG.match?('<foo bar="baz"/>'))
      assert(Markup::TAG.match?('</foo>'))

      refute(Markup::TAG.match?('< foo>'))
      refute(Markup::TAG.match?('<foo bar="<baz">'))
      refute(Markup::TAG.match?('<foo bar=baz>'))
      refute(Markup::TAG.match?('</foo bar="baz">'))
      refute(Markup::TAG.match?('</ foo>'))
    end

    def test_tag_scan
      text = 'foo <b>bar</b> <img alt="baz>"> bing <boing/>.'
      assert_equal(
        ['<b>', '</b>', '<img alt="baz>">', '<boing/>'],
        text.scan(Markup::TAG)
      )
    end
  end
end
