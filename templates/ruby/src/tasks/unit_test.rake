#
# Install a rake task for running examples written using rspec.
#
# More information about rspec: http://relishapp.com/rspec
# This file has been written to conform to RSpec v2.4.0
#
begin
  desc "Lauches unit tests"
  require 'rake/testtask'
  Rake::TestTask.new(:unit_test) do |t|

    # List of directories to added to $LOAD_PATH before running the
    # tests. (default is 'lib')
    t.libs = %w{ lib }

    # True if verbose test output desired. (default is false)
    t.verbose = false

    # Test options passed to the test suite.  An explicit TESTOPTS=opts 
    # on the command line will override this. (default is NONE)
    t.options = []

    # Request that the tests be run with the warning flag set.
    # E.g. warning=true implies "ruby -w" used to run the tests.
    t.warning = false

    # Glob pattern to match test files. (default is 'test/test*.rb')
    t.pattern = 'test/test*.rb'

    # Style of test loader to use.  Options are:
    #
    # * :rake -- Rake provided test loading script (default).
    # * :testrb -- Ruby provided test loading script.
    # * :direct -- Load tests using command line loader.
    # 
    t.loader = :rake

    # Array of commandline options to pass to ruby when running test 
    # loader.
    t.ruby_opts = []

    # Explicitly define the list of test files to be included in a
    # test.  +list+ is expected to be an array of file names (a
    # FileList is acceptable).  If both +pattern+ and +test_files+ are
    # used, then the list of test files is the union of the two.
    t.test_files = nil

  end
rescue LoadError => ex
  task :unit_test do
    abort 'rspec is not available. In order to run spec, you must: gem install rspec'
  end
ensure
  task :test => [:unit_test]
end

