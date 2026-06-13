# frozen_string_literal: true

require_relative 'lib/solargraph/yard_lint/version'

Gem::Specification.new do |spec|
  spec.name = 'solargraph-yard-lint'
  spec.version = Solargraph::YardLint::VERSION
  spec.authors = ['Lekë Mula']
  spec.email = ['leke.mula@gmail.com']

  spec.summary = 'Solargraph plugin that surfaces yard-lint offenses as LSP diagnostics'
  spec.description = 'Adds a yard_lint diagnostic reporter to Solargraph, powered by the ' \
                     'yard-lint gem. Surfaces YARD documentation issues in your editor.'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2'

  spec.metadata['source_code_uri'] = 'https://github.com/lekemula/solargraph-yard-lint'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ doc/ .git .github Gemfile])
    end
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'solargraph', '>= 0.52.0'
  spec.add_dependency 'yard-lint', '~> 1.6'
end
