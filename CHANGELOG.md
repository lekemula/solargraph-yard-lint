# Changelog

## 0.2.0

- Pass the editor's buffer contents to yard-lint via the new `source:` keyword
  (yard-lint 1.6+), so diagnostics now reflect unsaved edits. Bumps the
  yard-lint dependency to `~> 1.6`.

## 0.1.0

- Initial release.
- Registers a `yard_lint` diagnostic reporter that surfaces yard-lint
  offenses as LSP diagnostics.
