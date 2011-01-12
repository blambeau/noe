# We load Gemfile via Bundler in order to install gem dependencies
# automatically from information written there.
gem "bundler", "~> 1.0"
require "bundler"
$bundler_gemfile = Bundler.definition

# We require your library, mainly to have access to the VERSION number. 
# Feel free to set $version manually.
require File.expand_path('../lib/!{lower}', __FILE__)
$version = HelloWorld::VERSION.dup

#
# This is your Gem specification. Default values are provided so that your library
# should be correctly packaged given what you have described in the .noespec file.
#
Gem::Specification.new do |s|
  
  ################################################################### ABOUT YOUR GEM
  
  # Gem name (required) 
  s.name = %q{!{lower}}
  
  # Gem version (required)
  s.version = $version
  
  # A short summary of this gem
  #
  # This is displayed in `gem list -d`.
  s.summary = %q{!{summary}} 

  # A long description of this gem (required)
  #
  # The description should be more detailed than the summary.  For example,
  # you might wish to copy the entire README into the description.
  s.description = File.read(File.expand_path('../README.md', __FILE__))
  
  # The URL of this gem's home page (optional)
  s.homepage = %q{!{links.first}}

  # Gem publication date (required but auto)
  #
  # Today is automatically used by default, uncomment only if
  # you know what you do!
  #
  # s.date = Time.now.strftime('%Y-%m-%d')
  
  # The license(s) for the library.  Each license must be a short name, no
  # more than 64 characters.
  #
  # s.licences = %w{}

  # The rubyforge project this gem lives under (optional)
  #
  # s.rubyforge_project = nil

  ################################################################### ABOUT THE AUTHORS
  
  # The list of author names who wrote this gem.
  #
  # If you are providing multiple authors and multiple emails they should be
  # in the same order.
  # 
  s.authors = [ !{authors.collect{|a| "%q{#{a['name']}}"}.join(' ')} ]
  
  # Contact emails for this gem
  #
  # If you are providing multiple authors and multiple emails they should be
  # in the same order.
  #
  # NOTE: Somewhat strangly this attribute is always singular! 
  #       Don't replace by s.emails = ...
  s.email  = [ !{authors.collect{|a| "%q{#{a['email']}}"}.join(' ')} ]

  ################################################################### PATHS, FILES, BINARIES
  
  # Paths in the gem to add to $LOAD_PATH when this gem is 
  # activated (required).
  #
  # The default 'lib' is typically sufficient.
  s.require_paths = %w{ lib }
  
  # Files included in this gem.
  #
  # By default, we take all in lib, tasks + all non hidden files in the 
  # root folder. You don't have to include test files and binaries which 
  # are automatically included in packages
  #
  s.files = Dir['lib/**/*'] + 
            Dir['tasks/**/*'] +
            Dir['*'].select{|f| File.file?(f)}

  # Test files included in this gem.
  #
  s.test_files = Dir['test/**/*'] + Dir['spec/**/*']

  # The path in the gem for executable scripts (optional)
  #
  # Uncomment and set this as well as the following option if your gem 
  # has executables
  #
  # s.bindir = 'bin'

  # Executables included in the gem.
  #
  # s.executables = %w{}

  ################################################################### REQUIREMENTS & INSTALL
  # Remember the gem version requirements operators and schemes:
  #   =  Equals version
  #   != Not equal to version
  #   >  Greater than version
  #   <  Less than version
  #   >= Greater than or equal to
  #   <= Less than or equal to
  #   ~> Approximately greater than
  #
  # Don't forget to have a look at http://lmgtfy.com/?q=Ruby+Versioning+Policies 
  # for setting your gem version.
  #
  # For your requirements to other gems, remember that
  #   ">= 2.2.0"              (optimistic:  specify minimal version)
  #   ">= 2.2.0", "< 3.0"     (pessimistic: not greater than the next major)
  #   "~> 2.2"                (shortcut for ">= 2.2.0", "< 3.0")
  #   "~> 2.2.0"              (shortcut for ">= 2.2.0", "< 2.3.0")
  #

  #
  # One call to add_dependency('gem_name', 'gem version requirement')
  # for each normal dependency. These gems will be installed with your
  # gem. 
  #
  # One call to add_development_dependency('gem_name', 'gem version requirement')
  # for each development dependency.
  #
  # s.add_dependency('','~> x.y.z')
  # s.add_development_dependency('','~> x.y.z')
  #
  # In order to avoid having to maintain dependencies at two places, we use what has
  # been written in the Gemfile via the bundler gem.
  #
  $bundler_gemfile.dependencies.each do |dep|
    name, req = dep.name.to_s, dep.requirement.to_s
    unless dep.groups == [:development]
      s.add_dependency(name, req)
    end
    if dep.groups.include? :development
      s.add_development_dependency(name, req)
    end
  end

  # The version of ruby required by this gem
  #
  # Uncomment and set this if your gem requires specific ruby versions.
  #
  # s.required_ruby_version = ">= 0"

  # The RubyGems version required by this gem
  #
  # s.required_rubygems_version = ">= 0"

  # The platform this gem runs on.  See Gem::Platform for details.
  #
  # s.platform = nil

  # Extensions to build when installing the gem.  
  #
  # Valid types of extensions are extconf.rb files, configure scripts 
  # and rakefiles or mkrf_conf files.
  #
  # s.extensions = %w{}
  
  # External (to RubyGems) requirements that must be met for this gem to work. 
  # It’s simply information for the user.
  #
  # s.requirements = %w{}
  
  # A message that gets displayed after the gem is installed
  #
  # Uncomment and set this if you want to say something to the user
  # after gem installation
  #
  # s.post_install_message = nil

  ################################################################### SECURITY

  # The key used to sign this gem.  See Gem::Security for details.
  #
  # s.signing_key = nil

  # The certificate chain used to sign this gem.  See Gem::Security for
  # details.
  #
  # s.cert_chain = []
  
  ################################################################### RDOC

  # An ARGV style array of options to RDoc
  #
  # See 'rdoc --help' about this
  #
  s.rdoc_options = %w{}

  # Extra files to add to RDoc such as README
  #
  s.extra_rdoc_files = Dir['*.md'] + Dir['*.txt']

end
