# 1.2.0 / 2011-01-17

  * A 'description' variable is introduced in .noespec and made mandatory to avoid weird results 
    on rubygems.org when using the whole README.md file for project description.
  * A 'version' variable is introduced in .noespec and made mandatory.
  * Enhanced 'rake package/gem' to be configurable from .noespec under variables/rake_tasks/gem
  * Enhanced 'rake unit_test' to be configurable from .noespec under variables/rake_tasks/unit_test
  * Enhanced 'rake spec_test' to be configurable from .noespec under variables/rake_tasks/unit_test
  * Enhanced 'rake yard' to be configurable from .noespec under variables/rake_tasks/yard
  * Added 'rake debug_mail' which is configurable from .noespec under variables/rake_tasks/debug_mail
  * lib/__lower__/loader.rb only use plain requires instead of a more complex algorithm. This follows
    the discussion with Luis Lavena on ruby-talk (http://bit.ly/gqukPw)
  * Added a proposal dependency (wlang ~> 0.10.1) required by the debug_mail task

# 1.1.0 / 2011-01-11

  * Added the tasks folder with well documented rake tasks
  * Added a dependency loader in __lower__/loader.rb that helps requiring gems the good way
  * Added Bundler support to easy developer's job trough Gemfile and "require 'bundle/setup'" in Rakefile
  * LICENCE.txt -> LICENCE.md
  * Follows a lot of changes from Noe 1.0.0 -> 1.1.0

# 1.0.0 / 2011-01-11

  * Birthday