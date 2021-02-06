# frozen_string_literal: true

require 'test_helper'

module Srx
  class UtilTest < Minitest::Test
    def test_unwrap
      text = <<~TXT.chomp
        foo
        bar
        baz

        bazinga
      TXT
      assert_equal(<<~TXT.chomp, Util.unwrap(text))
        foo bar baz

        bazinga
      TXT
    end
  end
end
