# frozen_string_literal: true

module Srx
  # Engine for performing SRX segmenting
  class Engine
    # @return [Data]
    attr_reader :data

    # @param data [Data]
    # @param format [Symbol] see {Format#get}
    def initialize(data, format: :text)
      @data = data
      @format = Format.get(format)
    end

    # @param str [String]
    # @param language [String]
    # @return [Array<String>]
    def segment(str, language:)
      results = []
      rules = rules(language)

      plain_text, markups = @format.extract_markups(str)

      pos = 0
      breaks_by_pos(plain_text, rules).each do |break_pos, _|
        results << build_segment!(plain_text, markups, pos, break_pos)
        pos = break_pos
      end

      results
    end

    private

    # @param language [String]
    # @return [Array<Data::Rule>]
    def rules(language)
      names = rule_names(language)

      rule_map = @data.language_rules.map do |rule|
        [rule.name, rule]
      end.to_h

      names.flat_map { |name| rule_map[name].rules }
    end

    # @param language [String] nil treated as empty string
    # @return [Array<String>]
    def rule_names(language)
      language ||= ''

      @data.map_rules.map do |lang_map|
        next unless lang_map.language_pattern.match?(language)

        break [lang_map.language_rule_name] unless @data.cascade?

        lang_map.language_rule_name
      end.compact
    end

    # @param str [String]
    # @param rules [Array<Data::LanguageRule::Rule>]
    # @return [Array<Array(Integer,Data::LanguageRule::Rule)>] an array of pairs
    #   of 1) the position of a break, and 2) the rule that matched at that
    #   position. Note that the final break will always be at the end of the
    #   string and may not have an associated rule.
    def breaks_by_pos(str, rules)
      grouped = rules.flat_map { |rule| all_matches(str, rule) }
                     .group_by(&:first)
      grouped.transform_values! { |pairs| pairs.first.last }
      grouped.select! { |_pos, rule| rule.break? }
      result = grouped.sort_by(&:first)
      result << [str.length] unless result.last&.first == str.length
      result
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
    # @param markups [Array<Array(Integer,String)>]
    # @param start [Integer] start offset of segment in str
    # @param finish [Integer] end offset of segment in str
    def build_segment!(str, markups, start, finish)
      segment = str[start...finish]

      until markups.empty?
        markup_pos, markup = markups.first
        break unless start + segment.length >= markup_pos

        break if start + segment.length == markup_pos && !include_edge_formatting?(markup)

        segment.insert(markup_pos - start, markup)
        markups.shift
      end

      segment
    end

    # @param markup [String]
    # @return [Boolean] whether to include the specified edge markup in the
    #   current segment, in accordance with <formathandle> rules
    def include_edge_formatting?(markup)
      return false if !@data.include_start_formatting? && @format.start_formatting?(markup)
      return false if !@data.include_end_formatting? && @format.end_formatting?(markup)
      return false if !@data.include_isolated_formatting? && @format.isolated_formatting?(markup)

      true
    end
  end
end
