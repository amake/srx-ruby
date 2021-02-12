# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'srx'

require 'minitest/autorun'

def sample_engine(*args, **kwargs)
  Srx::Engine.new(Srx::Data.default, *args, **kwargs)
end

def segment(text:, language:, **_kwargs)
  sample_engine.segment(text, language: language).map(&:strip)
end
