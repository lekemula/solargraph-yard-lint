# frozen_string_literal: true

RSpec.describe Solargraph::YardLint::Diagnostic do
  let(:fixture_path) do
    File.absolute_path('spec/fixtures/offense').gsub('\\', '/')
  end

  it 'is registered as the yard_lint reporter' do
    expect(Solargraph::Diagnostics.reporter('yard_lint')).to eq(described_class)
  end

  it 'returns [] when the source has no filename' do
    source = Solargraph::Source.new("# @return [void]\ndef foo; end\n", '')
    expect(described_class.new.diagnose(source, nil)).to eq([])
  end

  it 'returns [] when the filename is not a .rb file' do
    source = Solargraph::Source.new("# @return [void]\ndef foo; end\n", '/tmp/notes.txt')
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

    it 'lints unsaved buffer content rather than the on-disk file' do
      file = File.realpath(File.join(fixture_path, 'app.rb'))
      buffer_code = <<~RUBY
        # frozen_string_literal: true

        # @param baz [Integer] does not exist on this method
        # @return [Integer]
        def another_method(qux)
          qux.length
        end
      RUBY
      source = Solargraph::Source.new(buffer_code, file)
      results = described_class.new.diagnose(source, nil)

      codes = results.map { |r| r[:code] }
      expect(codes).to include('UnknownParameterName')
      # The offense is on the `def another_method(qux)` line (index 4),
      # proving the buffer was parsed instead of the on-disk app.rb (where
      # the corresponding offense would land on line 5).
      offense = results.find { |r| r[:code] == 'UnknownParameterName' }
      expect(offense[:range][:start][:line]).to eq(4)
      expect(offense[:range][:end][:character]).to eq('def another_method(qux)'.length)
    end

    it 'lints buffer content even when the file does not exist on disk' do
      missing_path = File.join(fixture_path, 'missing.rb')
      expect(File.exist?(missing_path)).to be(false)
      source = Solargraph::Source.new(File.read(File.join(fixture_path, 'app.rb')), missing_path)
      results = described_class.new.diagnose(source, nil)

      expect(results).not_to be_empty
      expect(results.map { |r| r[:code] }).to include('UnknownParameterName')
    end
  end
end
