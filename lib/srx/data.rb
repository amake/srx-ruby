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
      # @param io [IO]
      # @return [Data]
      def from_io(io)
        new(Nokogiri::XML.parse(io))
      end
    end

    def segments_subflows?
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
    def languagerules
      xpath(:srx, :body, :languagerules, :languagerule)
        .map { |langrule| LanguageRule.new(langrule) }
    end

    # @return [Array<LanguageMap>]
    def maprules
      xpath(:srx, :body, :maprules, :languagemap)
        .map { |maprule| LanguageMap.new(maprule) }
    end

    private

    def header
      xpath(:srx, :header).first
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
      when :start then false
      when :end then true
      when :isolated then false
      else raise(ArgumentError, "Unknown formatting type: #{type}")
      end
    end

    class LanguageRule < XmlWrapper
      # @return [String]
      def name
        @xml['languagerulename']
      end

      # @return [Array<Rule>]
      def rules
        xpath(:rule).map { |rule| Rule.new(rule) }
      end

      class Rule < XmlWrapper
        def break?
          @xml['break'] == 'yes'
        end

        # @return [String,nil]
        def before_break
          xpath(:beforebreak)&.text
        end

        # @return [String,nil]
        def after_break
          xpath(:afterbreak)&.text
        end
      end
    end

    class LanguageMap < XmlWrapper
      # @return [String]
      def language_rule_name
        @xml['languagerulename']
      end

      # @return [String]
      def language_pattern
        @xml['languagepattern']
      end
    end
  end
end
