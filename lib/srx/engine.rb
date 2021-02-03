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

    # @param str [String]
    # @param lang_code [String]
    # @return [Array<String>]
    def segment(str, lang_code:)
      results = []
      rules = rules(lang_code)

      pos = 0
      loop do
        rule, match_pos = next_match(str, pos, rules)
        break unless rule

        results << str[pos...match_pos] if rule.break?
        pos = match_pos
      end

      results << str[pos...str.length] if pos < str.length

      results
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

    # @param str [String]
    # @param pos [Integer] the position to start searching from
    # @param rules [Array<Data::LanguageRule::Rule>]
    # @return [Array(Data::LanguageRule::Rule,Integer)] an array of 1) the next
    #   matching rule, and 2) the position at which it matched
    def next_match(str, pos, rules)
      next_matches(str, pos, rules).min_by { |_, match_pos| match_pos }
    end

    # @param str [String]
    # @param pos [Integer] the position to start searching from
    # @param rules [Array<Data::LanguageRule::Rule>]
    # @return [Array<Array(Data::LanguageRule::Rule,Integer)>] an array of pairs
    #   of 1) a matching rule, and 2) the position at which it matched
    def next_matches(str, pos, rules)
      rules.map do |rule|
        if rule.before_break
          rule.before_break.match(str, pos) do |m|
            [rule, m.end(0)] if rule.after_break.nil? || m.post_match.start_with?(rule.after_break)
          end
        elsif rule.after_break
          rule.after_break.match(str, pos) do |m|
            [rule, m.begin(0)]
          end
        else
          raise('Rule has neither before_break nor after_break')
        end
      end.compact
    end
  end
end
