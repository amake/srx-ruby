# frozen_string_literal: true

module Srx
  module Format
    # Interface definition for format support
    class BaseFormat
      # @abstract
      # @param str [String]
      # @return [Array(String,Array<Array(Integer,String)>)] two items: 1) input
      #   +str+ with markups removed, and 2) a list of markups, i.e. +[pos,
      #   string]+ pairs
      def extract_markups(str)
        raise(NotImplementedError)
      end

      # @abstract
      # @param markup [String]
      # @return [Boolean]
      def start_formatting?(markup)
        raise(NotImplementedError)
      end

      # @abstract
      # @param markup [String]
      # @return [Boolean]
      def end_formatting?(markup)
        raise(NotImplementedError)
      end

      # @abstract
      # @param markup [String]
      # @return [Boolean]
      def isolated_formatting?(markup)
        raise(NotImplementedError)
      end
    end
  end
end
