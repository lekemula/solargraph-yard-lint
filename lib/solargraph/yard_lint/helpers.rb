# frozen_string_literal: true

# Solargraph language server.
module Solargraph
  # yard-lint diagnostics plugin for Solargraph.
  module YardLint
    # Raised when a requested yard-lint version is not installed.
    class InvalidVersionError < RuntimeError; end

    # Utility methods for the yard-lint diagnostics reporter.
    module Helpers
      module_function

      # Requires a specific version of yard-lint, or the latest installed
      # version if _version_ is `nil`.
      #
      # @param version [String, nil]
      # @return [void]
      # @raise [InvalidVersionError] if _version_ is not installed
      def require_yard_lint version = nil
        begin
          gem_path = Gem::Specification.find_by_name('yard-lint', version).full_gem_path
          gem_lib_path = File.join(gem_path, 'lib')
          $LOAD_PATH.unshift(gem_lib_path) unless $LOAD_PATH.include?(gem_lib_path)
        rescue Gem::MissingSpecVersionError => e
          specs = e.specs
          raise InvalidVersionError,
                "could not find '#{e.name}' (#{e.requirement}) - " \
                "did find: [#{specs.map { |s| s.version.version }.join(', ')}]"
        end
        require 'yard-lint'
      end
    end
  end
end
