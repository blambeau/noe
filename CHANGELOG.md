# 1.1.1 / FIX ME

# 1.1.0 / 2011-01-11

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
