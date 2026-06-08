# solargraph-yard-lint

A [Solargraph](https://github.com/castwide/solargraph) plugin that surfaces
[yard-lint](https://github.com/mensfeld/yard-lint) offenses as LSP diagnostics
in your editor.

## Installation

Add to your project's `Gemfile`:

```ruby
group :development do
  gem 'solargraph'
  gem 'solargraph-yard-lint'
end
```

Then `bundle install`.

## Usage

Add to your project's `.solargraph.yml`:

```yaml
plugins:
  - solargraph-yard-lint
reporters:
  - rubocop
  - require_not_found
  - yard_lint
```

Restart your Solargraph language server. YARD documentation offenses will
appear as diagnostics in your editor.

Configure yard-lint itself via `.yard-lint.yml` in your project root — see
[yard-lint's documentation](https://github.com/mensfeld/yard-lint) for details.

## Notes

yard-lint reads files from disk and does not accept stdin, so this reporter
only lints sources whose buffer contents match the on-disk file. Unsaved
edits will not produce yard-lint diagnostics until the file is saved.

## License

MIT
