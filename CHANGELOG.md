# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- Add nil guard for `rhs.loc.expression` in `offense?` to prevent `NoMethodError`
  on incomplete AST nodes
- Autocorrect now computes indentation in visual columns, expanding tabs using
  `Layout/IndentationWidth` as the tab stop size. Leading tabs in corrected
  lines are replaced with spaces, producing correct alignment regardless of
  mixed tab/space indentation.

### Added

- Test: add `unless` and `kwbegin` (begin/rescue) offense and autocorrect cases
- Test: add nested context (assignment inside method body) autocorrect case
- Test: translate all spec comments from Japanese to English
- Test: add tab-indented source case to verify visual column autocorrect

### Docs

- Fix README Notes section: update `SafeAutoCorrect` description from `false`
  (character-count) to `true` (visual-column) to match current behavior

### Changed

- Set `SafeAutoCorrect: true` now that autocorrect handles tab indentation
  correctly
- Update `config/default.yml` comment to explain tab-to-space conversion
  behaviour
- Add `unless` and `kwbegin` examples to README

## [0.1.0] - 2026-02-20

### Added

- Initial release of `rubocop-multiline_rhs_on_new_line`
- Add `Layout/MultilineRhsOnNewLine` cop that enforces the RHS of an assignment
  to start on a new line when it spans multiple lines
- Support for `lvasgn`, `ivasgn`, `cvasgn`, and `gvasgn` node types
- Autocorrect support: inserts a newline and proper indentation after `=`

[Unreleased]: https://github.com/s4na/rubocop-multiline_rhs_on_new_line/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/s4na/rubocop-multiline_rhs_on_new_line/releases/tag/v0.1.0
