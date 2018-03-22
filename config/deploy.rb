# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "weekly_do"
set :repo_url, "git@bitbucket.org:ct2c/weekly_do.git"

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/nginx-apps/weekly_do'

# Default value for :scm is :git
set :scm, :git


# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :bundle_roles, :all
set :bundle_servers, -> { release_roles(fetch(:bundle_roles)) }
#set :bundle_binstubs, -> { shared_path.join('bin') }
#set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_path, false #-> { shared_path.join('vendor/bundle') }
set :bundle_without, %w{postgres sqlite therubyracer docker}.join(' ')
set :bundle_flags, '--system'
set :bundle_env_variables, {}

set :rvm_type, :system
set :rvm_ruby_version, '2.4.2'
set :passenger_rvm_ruby_version, '2.4.2'
set :passenger_restart_with_sudo, true
set :passenger_environment_variables, { :path => '/usr/local/rvm/gems/ruby-2.4.2/bin:$PATH' }

namespace :deploy do

  task :restart do
    on roles(:app) do
      within release_path do
        execute :touch, "tmp/restart.txt"
      end
    end

  end
  after :finishing, :restart
end
