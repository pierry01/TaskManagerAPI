source 'https://rubygems.org'

ruby '2.6.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.0'
gem 'devise'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'factory_girl_rails'
  gem 'faker'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
