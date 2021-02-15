# frozen_string_literal: true

require 'test_helper'

module Srx
  class IcuRegexTest < Minitest::Test
    def test_to_ruby_hex
      assert_equal(%q(\xff61), IcuRegex.to_ruby(%q(\xff61)))
      assert_equal(%q(\u{ff61}), IcuRegex.to_ruby(%q(\x{ff61})))
      assert_equal(%q(\u{ff6}), IcuRegex.to_ruby(%q(\x{ff6})))
      assert_equal(%q(\u{FF61}), IcuRegex.to_ruby(%q(\x{FF61})))
      assert_equal(%q(\xzf61), IcuRegex.to_ruby(%q(\xzf61)))

      assert_equal(%q(\u{1}), IcuRegex.to_ruby(%q(\x{1})))
      assert_equal(%q(\u{10}), IcuRegex.to_ruby(%q(\x{10})))
      assert_equal(%q(\u{10f}), IcuRegex.to_ruby(%q(\x{10f})))
      assert_equal(%q(\u{10ff}), IcuRegex.to_ruby(%q(\x{10ff})))
      assert_equal(%q(\u{10fff}), IcuRegex.to_ruby(%q(\x{10fff})))
      assert_equal(%q(\u{10ffff}), IcuRegex.to_ruby(%q(\x{10ffff})))

      assert_equal(
        %q([\u{ff61}\u{3002}\u{ff0e}\u{ff1f}\u{ff01}]+),
        IcuRegex.to_ruby(%q([\x{ff61}\x{3002}\x{ff0e}\x{ff1f}\x{ff01}]+))
      )
    end

    def test_to_ruby_oct
      assert_equal(%q(\0), IcuRegex.to_ruby(%q(\0)))
      assert_equal(%q(\u{1}), IcuRegex.to_ruby(%q(\01)))
      assert_equal(%q(\u{1f}), IcuRegex.to_ruby(%q(\037)))
      assert_equal(%q(\u{ff}), IcuRegex.to_ruby(%q(\0377)))
      assert_equal(%q(\0400), IcuRegex.to_ruby(%q(\0400)))
    end

    def test_compile
      assert_equal(/\u{ff61}\u{ff}/, IcuRegex.compile(%q(\x{ff61}\0377)))
    end
  end
end
