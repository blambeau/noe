# 1.7.0 / FIX ME

  * Added support for wlang-braces in manifest entries to generate wlang 
    templates without brace collisions.
  * Most important changes are in default ruby skeleton, see its own CHANGELOG

# 1.6.0 / 2011-12-09

  * Most important changes are in default ruby skeleton, see its own CHANGELOG
  * The project structure moved to ruby.noe 1.6.0 itself

# 1.5.1 / 2011-08-31

  * Most important changes are in default ruby skeleton, see its own CHANGELOG
  * Added a --silent option to 'noe prepare' that removes the "what's next" 
    message

# 1.5.0 / 2011-08-20

  * Most important changes are in default ruby skeleton, see its own CHANGELOG

# 1.4.0 / 2011-07-29

* Enhancements

  * Added an ignore entry in manifest that allows completely ignoring a file or 
    directory.
  * Moved to quickl 0.3.0
  * Most important changes are in default ruby skeleton, see its own CHANGELOG

# 1.3.0 / 2011-02-03

* Bug fixes

  * Fixed a bug in Hash merging when overriding boolean values
  * Fixed .gitignore of default ruby template not bundled with noe's gem, leading to incomplete templates
    instantiations
  
* Default ruby skeleton

  * Enhanced the way library version is handled. A !{upper}::Version module is now generated from
    the noespec (and is kept safe-overridable by default). !{upper}::VERSION is kept and is set by 
    that module to the correct value. As a side effect, the .gemspec can now be built even if 
    dependencies are not met.
  * Added the ability of the template to be tested with rubygems-test
  * spec/spec_helper.rb is not safe-override by default anymore
  * Fixed a bug that led 'rake -T' to ignore debug_mail

# 1.2.0 / 2011-01-17

* Broken things

  * Arrays are not union-merged anymore during YAML merging between .noespec and template's noespec.yaml. 
    This may introduce small problems on existing projects that use the default ruby skeleton while 
    specifying additional dependencies. Users have to copy default dependencies in their own .noespec 
    file.
  * Noe does not contain its loader anymore. As a side effect, it does not require rubygems anymore
    and 'noe' binary relies on the gem installer to meet its dependencies.

* Minor enhancements

  * Fixed 'noe --backtrace go', which didn't print the ruby backtrace.

* Bug fixes

  * A nil value on right of YAML merging (.noespec) correctly overrides the value specified on left
    (typically template's noespec.yaml)

* Default ruby skeleton

  * A 'description' variable is introduced in .noespec and made mandatory to avoid weird results 
    on rubygems.org when using the whole README.md file for project description.
  * Enhanced 'rake package/gem' to be configurable from .noespec under variables/rake_tasks/gem
  * Enhanced 'rake unit_test' to be configurable from .noespec under variables/rake_tasks/unit_test
  * Enhanced 'rake spec_test' to be configurable from .noespec under variables/rake_tasks/spec_test
  * Enhanced 'rake yard' to be configurable from .noespec under variables/rake_tasks/yard
  * Added 'rake debug_mail' which is configurable from .noespec under variables/rake_tasks/debug_mail
  * lib/__lower__/loader.rb only use plain requires instead of a more complex algorithm. This follows
    the discussion with Luis Lavena on ruby-talk (http://bit.ly/gqukPw)
  * Added a proposal dependency (wlang ~> 0.10.1) required by the debug_mail task
  * Fixed tasks/unit_test.rake under 1.9.2 (raised 'no such file to load -- []' with options=[] instead 
    of nil)

# 1.1.0 / 2011-01-14

* Template specification/instantiation enhancements

  * Introduced a manifest entry in template-info 
  * Introduced an auto detection of the wlang dialect to use based on file extensions. 
    The dialect may also be specified under template-info/manifest/a_file_name/wlang-dialect 
    entry
  * All hashes found in .noespec variables are methodized before being passed to template
  * Templates are now instantiated on a specification being the result of YAML merging 
    between the user's .noespec file and the template noespec.yaml file.

* Command enhancements

  * Removed 'noe create', which is replaced by an extended version named 'noe prepare'
  * 'noe go' now supports --interactive and --safe-override additional options to control conflict strategy
  * Added a 'noe show-spec' command that shows the complete specification used by 'noe go'
    See 'noe help show-spec' for details
  * 'noe COMMAND --help' is now an alias for 'noe help COMMAND'  
  * A wlang backtrace is now displayed when an instantation error occurs on 'noe go'

* Other changes

  * Bumped wlang version to 0.10.0 to gain inclusion features on wlang/ruby and wlang/yaml
  * Ruby skeleton largely enhanced (see it's own CHANGELOG.md)
  * Noe code is now managed by Noe itself

# 1.0.0 / 2011-01-10

* Enhancements

  * Birthday!
