# frozen_string_literal: true

require 'nokogiri'

module Srx
  # Abstract convenience wrapper around Nokogiri XML node
  class XmlWrapper
    NS = { 'srx' => 'http://www.lisa.org/srx20' }.freeze

    def initialize(xml)
      @xml = xml
    end

    def xpath(*segments)
      path = ['.', *segments].join('/srx:')
      @xml.xpath(path, NS)
    end
  end

  private_constant :XmlWrapper

  # SRX data
  class Data < XmlWrapper
    class << self
      # Default SRX rules
      #
      # @return [Data]
      def default
        from_file(path: File.expand_path('srx-20-sample.srx', __dir__))
      end

      # @param path [String]
      # @return [Data]
      def from_file(path:)
        File.open(path, &method(:from_io))
      end

      # @param io [IO]
      # @return [Data]
      def from_io(io)
        new(Nokogiri::XML.parse(io))
      end
    end

    def segment_subflows?
      header['segmentsubflows'] == 'yes'
    end

    def cascade?
      header['cascade'] == 'yes'
    end

    def include_start_formatting?
      include_formatting?(:start)
    end

    def include_end_formatting?
      include_formatting?(:end)
    end

    def include_isolated_formatting?
      include_formatting?(:isolated)
    end

    # @return [Array<LanguageRule>]
    def language_rules
      @language_rules ||=
        xpath(:srx, :body, :languagerules, :languagerule)
        .map { |langrule| LanguageRule.new(langrule) }
    end

    # @return [Array<LanguageMap>]
    def map_rules
      @map_rules ||=
        xpath(:srx, :body, :maprules, :languagemap)
        .map { |maprule| LanguageMap.new(maprule) }
    end

    private

    def header
      @header ||= xpath(:srx, :header).first
    end

    # @param type [Symbol]
    def format_handle(type)
      xpath(:srx, :header, "formathandle[@type='#{type}']").first
    end

    # @param type [Symbol]
    def include_formatting?(type)
      elem = format_handle(type)

      return elem['include'] == 'yes' if elem

      # Defaults are
      #   <formathandle type="start" include="no"/>
      #   <formathandle type="end" include="yes"/>
      #   <formathandle type="isolated" include="no"/>
      case type
      when %i[start isolated] then false
      when :end then true
      else raise(ArgumentError, "Unknown formatting type: #{type}")
      end
    end

    # SRX <languagerule> element
    class LanguageRule < XmlWrapper
      # @return [String]
      def name
        @xml['languagerulename']
      end

      # @return [Array<Rule>]
      def rules
        @rules ||= xpath(:rule).map { |rule| Rule.new(rule) }
      end

      # SRX <rule> element
      class Rule < XmlWrapper
        # @return [Regexp,nil]
        attr_reader :before_break

        # @return [Regexp,nil]
        attr_reader :after_break

        def initialize(xml)
          super(xml)

          # Eagerly load everything for this class because before_break and
          # after_break can be legitimately nil, so lazy loading gets ugly.

          @break = @xml['break'].nil? || @xml['break'] == 'yes'

          @before_break = xpath(:beforebreak).first&.text.then do |pattern|
            IcuRegex.compile(pattern) if pattern
          end

          @after_break ||= xpath(:afterbreak).first&.text.then do |pattern|
            IcuRegex.compile(pattern) if pattern
          end
        end

        def break?
          @break
        end

        def inspect
          "Rule[break=#{break?},before=#{before_break},after=#{after_break}]"
        end
      end
    end

    # SRX <languagemap> element
    class LanguageMap < XmlWrapper
      # @return [String]
      def language_rule_name
        @xml['languagerulename']
      end

      # @return [Regexp]
      def language_pattern
        @language_pattern ||= @xml['languagepattern'].then do |pattern|
          IcuRegex.compile(pattern) if pattern
        end
      end
    end
  end
end
