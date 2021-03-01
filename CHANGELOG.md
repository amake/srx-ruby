## [Unreleased]

- Improved HTML parsing accuracy

## [0.5.0] - 2021-02-25

- When `nil` is supplied for the `language` parameter, it is now treated as the
  empty string for rule-matching purposes (previously it would match no rules)

## [0.4.0] - 2021-02-18

- Optimize memory usage

## [0.3.0] - 2021-02-16

- All `Srx::Engine` methods except `#segment` are now private
- ICU regex syntax `\xhhhh` is now no longer converted to Ruby regex, as this
  syntax was not correct; it now must be `\x{hhhh}`
- ICU regex syntax `\0ooo` is now supported

## [0.2.0] - 2021-02-13

- Handle HTML void elements correctly

## [0.1.0] - 2021-02-13

- Initial release
