# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "timeboss/version"

Gem::Specification.new do |spec|
  spec.name = "timeboss"
  spec.version = TimeBoss::VERSION
  spec.authors = ["Kevin McDonald"]
  spec.email = ["kevinstuffandthings@gmail.com"]
  spec.summary = "Broadcast Calendar navigation in Ruby made simple"
  spec.description = spec.summary
  spec.homepage = "https://github.com/kevinstuffandthings/timeboss"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"

  spec.add_runtime_dependency "shellable"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "shellable"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "yard"
end
