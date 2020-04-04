# frozen_string_literal: true

require_relative 'lib/ambix'

require 'rake'
require 'kamaze/project'

Kamaze.project do |c|
  c.subject = Ambix
  c.name = 'ambix'
  #noinspection RubyLiteralArrayInspection
  c.tasks = [
    'cs', 'cs:pre-commit',
    'doc', 'doc:watch',
    'gem', 'gem:install',
    'misc:gitignore',
    'shell',
    'sources:license',
    'test',
    'version:edit',
  ].shuffle
end.load!

task default: [:gem]

if project.path('spec').directory?
  task :spec do |task, args|
    Rake::Task[:test].invoke(*args.to_a)
  end
end
