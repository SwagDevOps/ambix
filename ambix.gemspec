# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# rubocop:disable all

Gem::Specification.new do |s|
  s.name        = "ambix"
  s.version     = "0.0.1"
  s.date        = "2020-03-26"
  s.summary     = "Automatize video transformations"
  s.description = "Video transformations framework"

  s.licenses    = ["GPL-3.0"]
  s.authors     = ["Dimitri Arrigoni"]
  s.email       = "dimitri@arrigoni.me"
  s.homepage    = "https://github.com/SwagDevOps/ambix"

  # MUST follow the higher required_ruby_version
  # requires version >= 2.3.0 due to safe navigation operator &
  # requires version >= 2.5.0 due to yield_self
  s.required_ruby_version = ">= 2.5.0"
  s.require_paths = ["lib"]
  s.files         = [
    ".yardopts",
    "lib/ambix.rb",
    "lib/ambix/bundled.rb",
    "lib/ambix/version.rb",
    "lib/ambix/version.yml",
  ]

  s.add_runtime_dependency("rake", ["~> 13.0"])
  s.add_runtime_dependency("sys-proc", [">= 1.1.2", "~> 1.1"])
end

# Local Variables:
# mode: ruby
# End:
