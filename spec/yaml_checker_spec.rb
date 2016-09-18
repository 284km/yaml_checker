require "spec_helper"

describe YamlChecker do
  it "has a version number" do
    expect(YamlChecker::VERSION).not_to be nil
  end

  describe YamlChecker::Checker do
    describe ".run" do
      context "given nil" do
        let(:argv) { [nil] }
        it { expect { YamlChecker::Checker.run(argv) }.to raise_error(SystemExit) }
      end

      context "given empty string" do
        let(:argv) { [""] }
        it { expect { YamlChecker::Checker.run(argv) }.to raise_error(SystemExit) }
      end

      context "given file name .yml" do
        let(:argv) { ["spec/examples/valid.yml"] }
        it { expect(YamlChecker::Checker.run(argv)).to eq(true) }
      end

      context "given file name .yaml" do
        let(:argv) { ["spec/examples/valid.yaml"] }
        it { expect(YamlChecker::Checker.run(argv)).to eq(true) }
      end

      context "given invalid .yml" do
        let(:argv) { ["spec/examples/invalid.yml"] }
        it { expect(YamlChecker::Checker.run(argv)).to eq(false) }
      end

      context "given file name .txt" do
        let(:argv) { ["spec/examples/ignore.txt"] }
        it { expect(YamlChecker::Checker.run(argv)).to eq(false) }
      end

      context "given file name without extname" do
        let(:argv) { ["spec/examples/ignore"] }
        it { expect(YamlChecker::Checker.run(argv)).to eq(false) }
      end

      context "given directory name include only valid YAML files" do
        let(:argv) { ["spec/examples/valid"] }
        it { expect(YamlChecker::Checker.run(argv)).to eq(true) }
      end

      context "given directory name include invalid YAML files" do
        let(:argv) { ["spec/examples"] }
        it { expect(YamlChecker::Checker.run(argv)).to eq(false) }
      end
    end
  end
end
