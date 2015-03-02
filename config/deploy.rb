# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'swancon2015'
set :repo_url, 'git@github.com:WASFF/Swancon-Rails.git'
set :rvm_ruby_version, '2.1.1'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true


set :base_linked_files, %w{config/database.yml}
set :base_linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

require 'capistrano/git'
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :finishing, :tag_and_push_tag do 
    run_locally do
      user = capture(:git, "config --get user.name")
      email = capture(:git, "config --get user.email")
      tag_msg = "Deployed by #{user} <#{email}> to #{fetch :stage} as #{fetch :release_name}"
 
      tag_name = "deploys/2015/#{fetch :stage }"
      execute :git, %(push origin :refs/tags/#{tag_name})
      execute :git, %(tag -f #{tag_name} origin/#{fetch :branch} -m "#{tag_msg}")
      execute :git, "push origin #{tag_name}"
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
