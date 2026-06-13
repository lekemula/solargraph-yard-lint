# solargraph-yard-lint

[![CI](https://github.com/lekemula/solargraph-yard-lint/actions/workflows/ci.yml/badge.svg)](https://github.com/lekemula/solargraph-yard-lint/actions/workflows/ci.yml)

A [Solargraph](https://github.com/castwide/solargraph) plugin that surfaces
[yard-lint](https://github.com/mensfeld/yard-lint) offenses as LSP diagnostics
in your editor.

## Demo

https://github.com/lekemula/solargraph-yard-lint/raw/main/doc/solargraph-yard-lint-demo.mp4

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

```diff
 plugins:
+  - solargraph-yard-lint
 reporters:
+  - yard_lint
```

Restart your Solargraph language server. YARD documentation offenses will
appear as diagnostics in your editor.

Configure yard-lint itself via `.yard-lint.yml` in your project root — see
[yard-lint's documentation](https://github.com/mensfeld/yard-lint) for details.

## Contributing

Bug reports and pull requests are welcome at
[github.com/lekemula/solargraph-yard-lint](https://github.com/lekemula/solargraph-yard-lint).

```sh
bundle install
bundle exec rspec
bundle exec rubocop
bundle exec yard-lint lib/
```

Please run the full check suite locally before opening a PR — CI runs
the same three commands. New behavior should come with specs.

## License

MIT
