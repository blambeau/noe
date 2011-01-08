require File.expand_path('../lib/!{lower}', __FILE__)
spec = Gem::Specification.new do |s|
  s.name = %q{!{lower}}
  s.version = !{upper}::VERSION.dup
  s.date = Time.now.strftime('%Y-%m-%d')

  s.author = %q{!{author}}
  s.email = %q{!{email}}

  s.description = %q{!{description}}

  s.require_paths = ["lib"]
  s.executables = []

  s.extra_rdoc_files = ["README.md", "CHANGELOG.md"]

  s.files = 
    Dir['lib/**/*'] +
    Dir['spec/**/*'] +
    %w{ !{lower}.gemspec Rakefile README.md CHANGELOG.md LICENCE.txt}

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', ">= 2.4.0")
  s.add_development_dependency('yard', ">= 0.6.4")
  s.add_development_dependency('bluecloth', ">= 0.6.4")

  s.homepage = %q{!{homepage}}
end

