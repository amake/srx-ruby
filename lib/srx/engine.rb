# frozen_string_literal: true

require 'English'

module Srx
  # Engine for performing SRX segmenting
  class Engine
    # @return [Data]
    attr_reader :data

    # @param data [Data]
    # @param markup [Regexp]
    def initialize(data, format: :text)
      @data = data
      @markup_pattern =
        case format
        when :text then nil
        when :html, :xml
          require_relative 'markup'
          Markup::TAG
        else raise(ArgumentError, "Unknown format: #{format}")
        end
    end

    # @param str [String]
    # @param lang_code [String]
    # @return [Array<String>]
    def segment(str, lang_code:)
      results = []
      rules = rules(lang_code)

      plain_text, markups = extract_markups(str)

      pos = 0
      breaks_by_pos(plain_text, rules).each do |break_pos, _|
        results << build_segment!(plain_text, markups, pos, break_pos)
        pos = break_pos
      end

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
    #   position of a break, and 2) the rule that matched at that position. Note
    #   that the final break will always be at the end of the string and may not
    #   have an associated rule.
    def breaks_by_pos(str, rules)
      rules
        .flat_map { |rule| all_matches(str, rule) }
        .group_by(&:first)
        .transform_values { |pairs| pairs.first.last }
        .select { |_pos, rule| rule.break? }
        .sort_by(&:first)
        .tap { |breaks| breaks << [str.length] unless breaks&.last&.first == str.length }
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
          pos += 1 if pos == m.begin(0)

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

    # @param str [String]
    # @return [Array(String,Array<Array(Integer,String)>)] two items: 1) input
    #   +str+ with markups removed, and 2) a list of markups, i.e. +[pos,
    #   string]+ pairs
    def extract_markups(str)
      return [str, []] unless @markup_pattern

      markups = []

      plain_text = str.gsub(@markup_pattern) do |match|
        markups << [$LAST_MATCH_INFO.begin(0), match]
        ''
      end

      [plain_text, markups]
    end

    # @param str [String]
    # @param markups [Array<Array(Integer,String)>]
    # @param start [Integer] start offset of segment in str
    # @param finish [Integer] end offset of segment in str
    def build_segment!(str, markups, start, finish)
      segment = str[start...finish]

      until markups.empty?
        markup_pos, markup = markups.first
        break unless start + segment.length >= markup_pos

        segment.insert(markup_pos - start, markup)
        markups.shift
      end

      segment
    end
  end
end
