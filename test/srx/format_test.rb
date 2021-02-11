# frozen_string_literal: true

require 'test_helper'

module Srx
  class FormatTest < Minitest::Test
    def test_get
      refute_nil(Format.get(:text))
      refute_nil(Format.get(:xml))
      refute_nil(Format.get(:html))

      assert_raises(ArgumentError) do
        Format.get(:foo)
      end
    end
  end
end
