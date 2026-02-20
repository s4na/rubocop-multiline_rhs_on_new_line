# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-02-20

### Added

- Initial release of `rubocop-multiline_rhs_on_new_line`
- Add `Layout/MultilineRhsOnNewLine` cop that enforces the RHS of an assignment
  to start on a new line when it spans multiple lines
- Support for `lvasgn`, `ivasgn`, `cvasgn`, and `gvasgn` node types
- Autocorrect support: inserts a newline and proper indentation after `=`

[Unreleased]: https://github.com/s4na/rubocop-multiline_rhs_on_new_line/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/s4na/rubocop-multiline_rhs_on_new_line/releases/tag/v0.1.0
