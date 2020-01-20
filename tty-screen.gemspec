require_relative "lib/tty/screen/version"

Gem::Specification.new do |spec|
  spec.name          = "tty-screen"
  spec.version       = TTY::Screen::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = ["piotr@piotrmurach.com"]
  spec.summary       = %q{Terminal screen size detection which works on Linux, OS X and Windows/Cygwin platforms and supports MRI, JRuby and Rubinius interpreters.}
  spec.description   = %q{Terminal screen size detection which works on Linux, OS X and Windows/Cygwin platforms and supports MRI, JRuby and Rubinius interpreters.}
  spec.homepage      = "https://piotrmurach.github.io/tty/"
  spec.license       = "MIT"
  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "bug_tracker_uri"   => "https://github.com/piotrmurach/tty-screen/issues",
    "changelog_uri"     => "https://github.com/piotrmurach/tty-screen/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://www.rubydoc.info/gems/tty-screen",
    "homepage_uri"      => spec.homepage,
    "source_code_uri"   => "https://github.com/piotrmurach/tty-screen"
  }
  spec.files         = Dir["lib/**/*", "README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.0.0"
  spec.extra_rdoc_files = ["README.md"]

  spec.add_development_dependency "bundler", ">= 1.5.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "rake"
end
