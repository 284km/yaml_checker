require "yaml_checker/version"
require "yaml"

module YamlChecker
  def check(file_name)
    Checker.new(file_name).check
  end

  class Checker
    def self.run(*args)
      new(*args).run
    end

    def initialize(argv)
      @argv = argv
    end

    def run
      if File.directory?(path)
        Dir.glob("#{path}/**/*.{yml,yaml}").each do |f|
          load(f)
        end
        warn errors
        return errors.empty?
      elsif File.file?(path)
        if File.extname(path).match(/\.ya?ml/)
          load(path)
          warn errors
          return errors.empty?
        else
          warn "#{path}: File extname should be .yml or .yaml"
          return false
        end
      else
        warn "#{path}: No such file or directory"
        return false
      end
    end

    private

    def errors
      @errors ||= []
    end

    def load(file_name)
      YAML.load_file(file_name)
    rescue Exception => e
      errors << e
    end

    def path
      @path ||=
        if @argv.first.nil? || @argv.first.empty?
          warn usage
          abort "Missing file or directory path argument"
          @argv.first
        else
          File.expand_path(@argv.first)
        end
    end

    def usage
      <<-EOS
usage: yaml_checker <file(.yml/.yaml) or directory path>

      EOS
    end
  end
end
