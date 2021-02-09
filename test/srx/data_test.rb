# frozen_string_literal: true

require 'test_helper'

module Srx
  class DataTest < Minitest::Test
    def test_default
      refute_nil(Data.default)
    end

    def test_header
      srx = Data.default

      assert(srx.segments_subflows?)
      assert(srx.cascade?)

      refute_nil(srx.send(:format_handle, :start))

      refute(srx.include_start_formatting?)
      assert(srx.include_end_formatting?)
      assert(srx.include_isolated_formatting?)
    end

    def test_languagerules
      language_rules = Data.default.language_rules
      refute(language_rules.empty?)

      default = language_rules.first
      assert_equal('Default', default.name)

      rules = default.rules
      refute(rules.empty?)
    end

    def test_rule
      rule = Data.default.language_rules.first.rules.first

      refute(rule.break?)
      assert_equal(/^\s*[0-9]+\./, rule.before_break)
      assert_equal(/\s/, rule.after_break)
    end

    def test_maprules
      map_rules = Data.default.map_rules
      refute(map_rules.empty?)
    end

    def test_languagemap
      english = Data.default.map_rules.first

      assert_equal('English', english.language_rule_name)
      assert_equal(/[Ee][Nn].*/, english.language_pattern)
    end
  end
end
