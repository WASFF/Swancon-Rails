# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'swancon2017'
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

  desc 'Compile assets'
  task :compile_assets => [:set_rails_env] do
    # invoke 'deploy:assets:precompile'
    invoke 'deploy:assets:precompile_local'
    invoke 'deploy:assets:backup_manifest'
  end

  namespace :assets do
    
    desc "Precompile assets locally and then rsync to web servers" 
    task :precompile_local do 
      # compile assets locally
      run_locally do
        execute "RAILS_ENV=#{fetch(:stage)} bundle exec rake assets:precompile"
      end
 
      # rsync to each server
      local_dir = "./public/assets/"
      on roles( fetch(:assets_roles, [:web]) ) do
        # this needs to be done outside run_locally in order for host to exist
        remote_dir = "#{host.user}@#{host.hostname}:#{release_path}/public/assets/"
    
        run_locally { execute "rsync -av --delete #{local_dir} #{remote_dir}" }
      end
 
      # clean up
      run_locally { execute "rm -rf #{local_dir}" }
    end
    
  end

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
 
      tag_name = "deploys/2017/#{fetch :stage }"
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
