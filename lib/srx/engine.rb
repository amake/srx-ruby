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
      breaks_by_pos(str, rules).each do |break_pos, _|
        results << str[pos...break_pos]
        pos = break_pos
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
    # @return [Array(Integer,Data::LanguageRule::Rule)] an array of 1) the
    #   position of a break, and 2) the rule that matched at that position
    def breaks_by_pos(str, rules)
      rules
        .flat_map { |rule| all_matches(str, rule) }
        .group_by(&:first)
        .transform_values { |pairs| pairs.first.last }
        .select { |_pos, rule| rule.break? }
    end

    # @param str [String]
    # @param rule [Data::LanguageRule::Rule]
    # @return [Array<Array(Integer,Data::LanguageRule::Rule)>]
    def all_matches(str, rule)
      results = []

      pos = 0
      while pos < str.length
        if rule.before_break
          m = rule.before_break.match(str, pos)
          break unless m

          pos = m.end(0)
          results << [pos, rule] if rule.after_break.nil? || m.post_match.start_with?(rule.after_break)
        elsif rule.after_break
          m = rule.after_break.match(str, pos)
          break unless m

          pos = m.begin(0) + 1
          results << [pos, rule]
        else
          raise('Rule has neither before_break nor after_break')
        end
      end

      results
    end
  end
end
