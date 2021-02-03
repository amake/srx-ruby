# frozen_string_literal: true

module Srx
  # Engine for performing SRX segmenting
  class Engine
    # @return [Data]
    attr_reader :data

    # @param data [Data]
    def initialize(data)
      @data = data
    end

    # @param lang_code [String]
    # @return [Array<Data::Rule>]
    def rules(lang_code)
      names = rule_names(lang_code)

      rule_map = @data.language_rules.map do |rule|
        [rule.name, rule]
      end.to_h

      names.flat_map { |name| rule_map[name].rules }
    end

    # @param lang_code [String]
    # @return [Array<String>]
    def rule_names(lang_code)
      @data.map_rules.map do |lang_map|
        next unless lang_map.language_pattern.match?(lang_code)

        break [lang_map.language_rule_name] unless @data.cascade?

        lang_map.language_rule_name
      end.compact
    end
  end
end
