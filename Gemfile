source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'factory_bot_rails', '~> 6.4.4'
  gem 'rspec-rails', '~> 5.0.0'
  gem 'rspec_junit_formatter'

  # メール送信確認用
  gem 'letter_opener_web', '~> 2.0'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  # gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'capybara'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'

# ユーザー認証
gem 'sorcery'

# i18n
gem 'rails-i18n'

# enumの日本語化
gem 'enum_help'

# 初期データ作成
gem 'seed-fu'

# 画像アップロード
gem 'carrierwave', '~> 2.0'

# 画像のエラーメッセージの日本語化
gem 'carrierwave-i18n'

# 画像のリサイズ
gem 'mini_magick'

# 翻訳API
gem 'google-cloud'
gem 'google-cloud-translate'

# グラフ
gem 'chart-js-rails'
gem 'gon'

# デコレータ
gem 'draper'

# AWS S3
gem 'fog-aws'

# 管理者画面
gem 'rails_admin', '~> 2.0'
gem 'rails_admin-i18n'

# 認可機能
gem 'cancancan'

# ページネーション
gem 'pagy', '~> 5.10'
