# frozen_string_literal: true

require 'test_helper'

module Srx
  class EngineTest < Minitest::Test
    def test_initialize
      refute_nil(sample_engine)

      assert_raises(ArgumentError) do
        sample_engine(format: :pdf)
      end
    end

    def test_rule_names
      engine = sample_engine
      assert_equal(%w[English Default], engine.send(:rule_names, 'en'))
      assert_equal(%w[Japanese Default], engine.send(:rule_names, 'JA'))
      assert_equal(%w[Default], engine.send(:rule_names, 'zh'))
    end

    # rubocop:disable Style/RedundantRegexpEscape
    def test_rules
      engine = sample_engine
      assert_equal(
        [/\s[Ee][Tt][Cc]\./, /\sMr\./, /\sU\.K\./, /^\s*[0-9]+\./, nil, /[\.\?!]+/],
        engine.send(:rules, 'en').map(&:before_break)
      )
      assert_equal(
        [/\s[a-z]/, /\s/, /\s/, /\s/, /\n/, /\s/],
        engine.send(:rules, 'en').map(&:after_break)
      )
      assert_equal(
        [/[\u{ff61}\u{3002}\u{ff0e}\u{ff1f}\u{ff01}]+/, /^\s*[0-9]+\./, nil, /[\.\?!]+/],
        engine.send(:rules, 'JA').map(&:before_break)
      )
      assert_equal(
        [//, /\s/, /\n/, /\s/],
        engine.send(:rules, 'JA').map(&:after_break)
      )
      assert_equal(
        [/^\s*[0-9]+\./, nil, /[\.\?!]+/],
        engine.send(:rules, 'zh').map(&:before_break)
      )
      assert_equal(
        [/\s/, /\n/, /\s/],
        engine.send(:rules, 'zh').map(&:after_break)
      )
    end
    # rubocop:enable Style/RedundantRegexpEscape

    def test_segment
      engine = sample_engine

      assert_equal(
        ['a.', ' b?', ' c!', ' d.'],
        engine.segment('a. b? c! d.', language: 'zz')
      )

      assert_equal(
        ['The U.K. Prime Minister, Mr. Blair, was seen out with his family today.'],
        engine.segment('The U.K. Prime Minister, Mr. Blair, was seen out with his family today.', language: 'en')
      )

      assert_equal(
        ['The U.K.', ' Prime Minister, Mr.', ' Blair, was seen out with his family today.'],
        engine.segment('The U.K. Prime Minister, Mr. Blair, was seen out with his family today.', language: 'zz')
      )

      assert_equal(
        ['こんにちは。', 'お元気ですか？', 'はい、元気です。'],
        engine.segment('こんにちは。お元気ですか？はい、元気です。', language: 'ja')
      )

      text = File.open('LICENSE.txt', &:read).strip.then { |t| Util.unwrap(t) }
      segments = engine.segment(text, language: 'en')
      assert_equal(11, segments.length)
      assert_equal("The MIT License (MIT)\n", segments.first)
      assert_equal(<<~TXT.chomp, segments.last)
        \ IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
      TXT
    end

    def test_html
      engine = sample_engine(format: :html)

      assert_equal(
        ['Hello <img alt="foo. bar"> world!'],
        engine.segment('Hello <img alt="foo. bar"> world!', language: 'en')
      )
      assert_equal(
        ['Hello, world!', " <i>What's up?</i>"],
        engine.segment("Hello, world! <i>What's up?</i>", language: 'en')
      )
      assert_equal(
        ['<i>Hello, world!</i>', " What's up?"],
        engine.segment("<i>Hello, world!</i> What's up?", language: 'en')
      )
    end

    def test_formathandle
      engine = sample_engine(format: :html)

      assert_equal(
        ['Hello, world!', "<i> What's up?</i>"],
        engine.segment("Hello, world!<i> What's up?</i>", language: 'en')
      )
      assert_equal(
        ['Hello, world!<img />', " What's up?"],
        engine.segment("Hello, world!<img /> What's up?", language: 'en')
      )
      assert_equal(
        ['<i>Hello, world!</i>', " What's up?"],
        engine.segment("<i>Hello, world!</i> What's up?", language: 'en')
      )
    end
  end
end
