# frozen_string_literal: true

RSpec.describe Solargraph::YardLint::Diagnostic do
  let(:fixture_path) do
    File.absolute_path('spec/fixtures/offense').gsub('\\', '/')
  end

  it 'is registered as the yard_lint reporter' do
    expect(Solargraph::Diagnostics.reporter('yard_lint')).to eq(described_class)
  end

  it 'returns [] for sources without an on-disk filename' do
    source = Solargraph::Source.new("# @return [void]\ndef foo; end\n", '')
    expect(described_class.new.diagnose(source, nil)).to eq([])
  end

  context 'with a local yard-lint config' do
    around do |example|
      Dir.chdir(fixture_path) { example.run }
    end

    it 'returns an Array of diagnostics' do
      file = File.realpath(File.join(fixture_path, 'app.rb'))
      source = Solargraph::Source.load(file)
      result = described_class.new.diagnose(source, nil)
      expect(result).to be_a(Array)
    end

    it 'maps yard-lint offenses to LSP diagnostics' do
      file = File.realpath(File.join(fixture_path, 'app.rb'))
      source = Solargraph::Source.load(file)
      results = described_class.new.diagnose(source, nil)

      expect(results).not_to be_empty
      offense = results.first
      expect(offense[:source]).to eq('yard-lint')
      expect(offense[:severity]).to eq(Solargraph::Diagnostics::Severities::ERROR)
      expect(offense[:code]).to eq('UnknownParameterName')
      expect(offense[:range][:start][:line]).to eq(5)
      expect(offense[:range][:start][:character]).to eq(0)
      expect(offense[:range][:end][:line]).to eq(5)
      expect(offense[:range][:end][:character]).to eq('def my_method(foo)'.length)
    end
  end
end
