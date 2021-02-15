# SRX for Ruby

SRX is a specification for segmenting text, i.e. splitting text into sentences.
More specifically it is

- An XML-based format for specifying segmentation rules, and
- An algorithm by which the rules are applied

See the [SRX 2.0 Specification](http://www.ttt.org/oscarStandards/srx/srx20.html)
for full details.

This gem provides facilities for reading SRX files and an engine for performing
segmentation.

Only a minimal rule set is supplied by default; for actual usage you are
encouraged to supply your own SRX rules. One such set of rules is that from
[LanguageTool](https://languagetool.org/); this is conveniently packaged into a
companion gem:
[srx-languagetool-ruby](https://github.com/amake/srx-languagetool-ruby).

## What's different about this gem?

There are lots of good segmentation gems out there such as

- [pragmatic_segmenter](https://github.com/diasks2/pragmatic_segmenter)
- [TactfulTokenizer](https://github.com/zencephalon/Tactful_Tokenizer)
- [Punkt](https://github.com/lfcipriani/punkt-segmenter)

What makes SRX different is:

- It allows easy customization and exchange of rules via SRX files
- It preserves whitespace surrounding break points
- It offers advanced XML/HTML tag handling: it won't be fooled by false breaks
  in e.g. attribute values

Some other advantages that are not unique to SRX:

- It is offered under a very permissive license
- It is relatively lightweight as a dependency
- It is fast (though this depends somewhat on the ruleset you use)

Some disadvantages:

- It is inherently rule-based, with all of the weaknesses that implies
- It is not very accurate on the [Golden Rules
  test](https://github.com/diasks2/pragmatic_segmenter#comparison-of-segmentation-tools-libraries-and-algorithms),
  scoring 47% (English) and 48% (others) with the default rules. However you can
  improve on that with better rules such as
  [LanguageTool's](https://github.com/amake/srx-languagetool-ruby).

## Caveats

The SRX spec calls for [ICU regular
expressions](https://unicode-org.github.io/icu/userguide/strings/regexp.html),
but this library uses standard [Ruby
regexp](https://ruby-doc.org/core-2.7.0/Regexp.html). Please note:

- Not all ICU syntax is supported
- For supported syntax, in some cases the meaning of a regex may differ when
  interpreted as Ruby regexp
- The following ICU syntax is supported through translation to Ruby syntax:
  - `\x{hhhh}` → `\u{hhhh}`
  - `\0ooo` → `\u{hhhh}`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'srx'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install srx

## Usage

Use the default rules like so. Specify the language according the `<maprules>`
of your SRX (usually two-letter [ISO 639-1
codes](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)).

```ruby
require 'srx'

data = Srx::Data.default
engine = Srx::Engine.new(data)
engine.segment('Hi. How are you?', language: 'en') #=> ["Hi.", " How are you?"]
```

Or bring your own rules:

```ruby
data = Srx::Data.from_file(path: 'path/to/my/rules.srx')
engine = Srx::Engine.new(data)
```

Specify the format as `:xml` or `:html` to benefit from special handling of
tags:

```ruby
# This should only be one segment, but handling as plain text incorrectly
# produces two segments.
input = 'foo <bar baz="a. b."> bazinga'

Srx::Engine.new(Data.default).segment(input, language: 'en')
#=> ["foo <bar baz=\"a.", " b.\"> bazinga"]

Srx::Engine.new(data, format: :xml).segment(input, language: 'en')
#=> ["foo <bar baz=\"a. b.\"> bazinga"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/amake/srx.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
