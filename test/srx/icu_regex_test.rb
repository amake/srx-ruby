# frozen_string_literal: true

require 'test_helper'

module Srx
  class IcuRegexTest < Minitest::Test
    def test_to_ruby
      assert_equal('\\xff61', IcuRegex.to_ruby('\\xff61'))
      assert_equal('\\u{ff61}', IcuRegex.to_ruby('\\x{ff61}'))
      assert_equal('\\u{ff6}', IcuRegex.to_ruby('\\x{ff6}'))
      assert_equal('\\u{FF61}', IcuRegex.to_ruby('\\x{FF61}'))
      assert_equal('\\xzf61', IcuRegex.to_ruby('\\xzf61'))
      assert_equal('\\\\xff61', IcuRegex.to_ruby('\\\\xff61'))

      assert_equal('\\u{1}', IcuRegex.to_ruby('\\x{1}'))
      assert_equal('\\u{10}', IcuRegex.to_ruby('\\x{10}'))
      assert_equal('\\u{10f}', IcuRegex.to_ruby('\\x{10f}'))
      assert_equal('\\u{10ff}', IcuRegex.to_ruby('\\x{10ff}'))
      assert_equal('\\u{10fff}', IcuRegex.to_ruby('\\x{10fff}'))
      assert_equal('\\u{10ffff}', IcuRegex.to_ruby('\\x{10ffff}'))

      assert_equal(
        '[\\u{ff61}\\u{3002}\\u{ff0e}\\u{ff1f}\\u{ff01}]+',
        IcuRegex.to_ruby('[\\x{ff61}\\x{3002}\\x{ff0e}\\x{ff1f}\\x{ff01}]+')
      )
    end

    def test_compile
      assert_equal(/\u{ff61}/, IcuRegex.compile('\\x{ff61}'))
    end
  end
end
