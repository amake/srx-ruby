# frozen_string_literal: true

require 'test_helper'

module Srx
  class IcuRegexTest < Minitest::Test
    def test_to_ruby
      assert_equal('\\uff61', IcuRegex.to_ruby('\\xff61'))
      assert_equal('\\uFF61', IcuRegex.to_ruby('\\xFF61'))
      assert_equal('\\u{ff61}', IcuRegex.to_ruby('\\x{ff61}'))
      assert_equal('\\xzf61', IcuRegex.to_ruby('\\xzf61'))
      assert_equal('\\\\xff61', IcuRegex.to_ruby('\\\\xff61'))

      assert_equal(
        '[\\uff61\\u3002\\uff0e\\uff1f\\uff01]+',
        IcuRegex.to_ruby('[\\xff61\\x3002\\xff0e\\xff1f\\xff01]+')
      )
    end

    def test_compile
      assert_equal(/\uff61/, IcuRegex.compile('\\xff61'))
    end
  end
end
