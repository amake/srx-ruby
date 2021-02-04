# frozen_string_literal: true

require 'test_helper'

module Srx
  class EngineTest < Minitest::Test
    def test_initialize
      refute_nil(sample_engine)
    end

    def test_rule_names
      engine = sample_engine
      assert_equal(%w[English Default], engine.rule_names('en'))
      assert_equal(%w[Japanese Default], engine.rule_names('JA'))
      assert_equal(%w[Default], engine.rule_names('zh'))
    end

    # rubocop:disable Style/RedundantRegexpEscape
    def test_rules
      engine = sample_engine
      assert_equal(
        [/\s[Ee][Tt][Cc]\./, /\sMr\./, /\sU\.K\./, /^\s*[0-9]+\./, nil, /[\.\?!]+/],
        engine.rules('en').map(&:before_break)
      )
      assert_equal(
        [/\s[a-z]/, /\s/, /\s/, /\s/, /\n/, /\s/],
        engine.rules('en').map(&:after_break)
      )
      assert_equal(
        [/[\uff61\u3002\uff0e\uff1f\uff01]+/, /^\s*[0-9]+\./, nil, /[\.\?!]+/],
        engine.rules('JA').map(&:before_break)
      )
      assert_equal(
        [//, /\s/, /\n/, /\s/],
        engine.rules('JA').map(&:after_break)
      )
      assert_equal(
        [/^\s*[0-9]+\./, nil, /[\.\?!]+/],
        engine.rules('zh').map(&:before_break)
      )
      assert_equal(
        [/\s/, /\n/, /\s/],
        engine.rules('zh').map(&:after_break)
      )
    end
    # rubocop:enable Style/RedundantRegexpEscape

    def test_segment
      engine = sample_engine

      assert_equal(
        ['a.', ' b?', ' c!', ' d.'],
        engine.segment('a. b? c! d.', lang_code: 'zz')
      )

      assert_equal(
        ['The U.K. Prime Minister, Mr. Blair, was seen out with his family today.'],
        engine.segment('The U.K. Prime Minister, Mr. Blair, was seen out with his family today.', lang_code: 'en')
      )

      assert_equal(
        ['The U.K.', ' Prime Minister, Mr.', ' Blair, was seen out with his family today.'],
        engine.segment('The U.K. Prime Minister, Mr. Blair, was seen out with his family today.', lang_code: 'zz')
      )

      text = File.open('LICENSE.txt', &:read).strip
      segments = engine.segment(text, lang_code: 'en')
      assert_equal(23, segments.length)
      assert_equal("The MIT License (MIT)\n", segments.first)
      assert_equal('THE SOFTWARE.', segments.last)
    end

    private

    def sample_engine
      data = File.open('test/srx-20-sample.srx') { |f| Data.from_io(f) }
      Engine.new(data)
    end
  end
end
