require File.expand_path('../lib/noe', __FILE__)
spec = Gem::Specification.new do |s|
  s.name = %q{noe}
  s.version = Noe::VERSION.dup
  s.date = Time.now.strftime('%Y-%m-%d')

  s.author = %q{Bernard Lambeau}
  s.email = %q{blambeau@gmail.com}

  s.description = %q{Probably the simplest project generator from templates}
  s.summary = %q{Probably the simplest project generator from templates}

  s.require_paths = ["lib"]
  s.bindir = "bin"
  s.executables = ["noe"]

  s.extra_rdoc_files = ["README.md", "CHANGELOG.md"]

  s.files = 
    Dir['lib/**/*'] +
    Dir['spec/**/*'] +
    %w{ noe.gemspec Rakefile README.md CHANGELOG.md LICENCE.txt}
    
  s.add_dependency('wlang',  '>= 0.9.2')
  s.add_dependency('quickl', '>= 0.2.0')

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', ">= 2.4.0")
  s.add_development_dependency('yard', ">= 0.6.4")
  s.add_development_dependency('bluecloth', ">= 0.6.4")

  s.homepage = %q{http://github.com/blambeau/noe}
end

