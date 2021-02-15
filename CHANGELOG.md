## [Unreleased]

- All `Srx::Engine` methods except `#segment` are now private
- ICU regex syntax `\xhhhh` is now no longer converted to Ruby regex, as this
  syntax was not correct; it now must be `\x{hhhh}`
- ICU regex syntax `\0ooo` is now supported

## [0.2.0] - 2021-02-13

- Handle HTML void elements correctly

## [0.1.0] - 2021-02-13

- Initial release
