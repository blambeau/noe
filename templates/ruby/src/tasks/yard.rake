# 
# Install a rake task to generate API documentation using
# yard.
#
# More information about yard: http://yardoc.org/
# This file has been written to conform to yard v0.6.4
#
# About project documentation
begin
  require "yard"
  desc "Generate yard documentation"
  YARD::Rake::YardocTask.new(:yard) do |t|
    # Array of options passed to the commandline utility
    # See 'yardoc --help' about this
    t.options = %w{--output-dir doc/api - README.md CHANGELOG.md}
    
    # Array of ruby source files (and any extra documentation files 
    # separated by '-')
    t.files = ['lib/**/*.rb']
    
    # A proc to call before running the task
    # t.before = proc{ }
    
    # A proc to call after running the task
    # r.after = proc{ }
    
    # An optional lambda to run against all objects being generated. 
    # Any object that the lambda returns false for will be excluded 
    # from documentation. 
    # t.verifier = lambda{|obj| true}
  end
rescue LoadError
  task :yard do
    abort 'yard is not available. In order to run yard, you must: gem install yard'
  end
end
