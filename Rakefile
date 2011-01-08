require "rake/gempackagetask"
require "rspec/core/rake_task"
require "yard"

# We run tests by default
task :default => :spec

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
	t.rspec_opts = %w[--color]
	t.verbose = false
end

# About yard documentation
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = ['--output-dir', 'doc/api', '-', "README.md", "CHANGELOG.md"]
end

desc "Create the .gem package"
$spec = Kernel.eval(File.read(File.expand_path('../noe.gemspec', __FILE__)))
Rake::GemPackageTask.new($spec) do |pkg|
	pkg.need_tar = true
end
