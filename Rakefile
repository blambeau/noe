# Dynamically load the gem spec
$gemspec_file = File.expand_path('../noe.gemspec', __FILE__)
$gemspec      = Kernel.eval(File.read($gemspec_file))

# We run tests by default
task :default => :test

#
# Install all tasks found in tasks folder
#
# See .rake files there for complete documentation.
#
Dir["tasks/*.rake"].each do |taskfile|
  load taskfile
end
