# rubocop:disable Naming/FileName
# frozen_string_literal: true

require 'solargraph'

require_relative 'solargraph/yard_lint/version'
require_relative 'solargraph/yard_lint/helpers'
require_relative 'solargraph/yard_lint/diagnostic'

Solargraph::Diagnostics.register('yard_lint', Solargraph::YardLint::Diagnostic)
# rubocop:enable Naming/FileName
