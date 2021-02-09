# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'srx'

require 'minitest/autorun'

def sample_engine
  Srx::Engine.new(Srx::Data.default)
end

def segment(text:, language:, **_kwargs)
  sample_engine.segment(text, lang_code: language).map(&:strip)
end
