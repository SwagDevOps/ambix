# frozen_string_literal: true

# bundle install --clean --path vendor/bundle
source 'https://rubygems.org'
git_source(:github) { |name| "https://github.com/#{name}.git" }

group :default do
  gem 'rake', '~> 13.0'
  gem 'sys-proc', '~> 1.1', '>= 1.1.2'
end

group :development do
  gem 'kamaze-project', { github: 'SwagDevOps/kamaze-project', branch: 'develop' }
  gem 'rubocop', '~> 0.79'
  gem 'rugged', '~> 0.28'
end

group :doc do
  gem 'github-markup', '~> 3.0'
  gem 'redcarpet', '~> 3.5'
  gem 'yard', '~> 0.9'
end

group :repl do
  gem 'interesting_methods', '~> 0.1'
  gem 'pry', '~> 0.12'
end

group :test do
  gem 'rspec', '~> 3.8'
  gem 'sham', '~> 2.0'
  gem 'simplecov', '~> 0.16'
end
