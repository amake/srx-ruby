# frozen_string_literal: true

require 'test_helper'

module Srx
  module Format
    class TextTest < Minitest::Test
      def test_extract_markups
        sut = Text.new
        text = 'foo <b>bar</b> <img alt="baz>"> bing <boing/>.'
        plain_text, markups = sut.extract_markups(text)
        assert_equal(text, plain_text)
        assert_equal([], markups)
      end

      def test_start_formatting?
        sut = Text.new
        assert_raises(NotImplementedError) do
          sut.start_formatting?('<foo>')
        end
      end

      def test_end_formatting?
        sut = Text.new
        assert_raises(NotImplementedError) do
          sut.end_formatting?('<foo>')
        end
      end

      def test_isolated_formatting?
        sut = Text.new
        assert_raises(NotImplementedError) do
          sut.isolated_formatting?('<foo>')
        end
      end
    end
  end
end
