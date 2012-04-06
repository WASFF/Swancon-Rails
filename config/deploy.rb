require "bundler/capistrano"

set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-1.9.2-p290/bin:/usr/local/rvm/bin:$PATH",
  'RUBY_VERSION' => 'ruby 1.9.2',
  'GEM_HOME'     => '/usr/local/rvm/gems/ruby-1.9.2-p290',
  'GEM_PATH'     => '/usr/local/rvm/gems/ruby-1.9.2-p290',
  'BUNDLE_PATH'  => '/usr/local/rvm/gems/ruby-1.9.2-p290'  # If you are using bundler.
}

set :application, "Swancon Rails App"
set :repository,  "git://github.com/lordmortis/Swancon-Rails.git"
set :user, 'wasff'
set :default_shell, 'bash'
set :rake, 'bundle exec rake'

set :scm, :git
#set :git_enable_submodules, 1 # if you have vendored rails
set :branch, "master"
set :git_shallow_clone, 1
#set :scm_verbose, true
set :use_sudo, false

role :web, "clientweb.sektorseven.net"                          # Your HTTP server, Apache/etc
role :app, "clientweb.sektorseven.net"                          # This may be the same as your `Web` server
role :db,  "clientweb.sektorseven.net", :primary => true # This is where Rails migrations will run

set :deploy_to, "/home/wasff/2013/"
set :deploy_via, :export

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
	task :start do ; end
	task :stop do ; end
	task :restart, :roles => :app, :except => { :no_release => true } do
		run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
	end
end

before "deploy:symlink", "assets:precompile"

namespace :assets do
  desc "Compile assets"
  task :precompile, :roles => :app do
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets" 
    run "cd #{release_path} && bundle exec rake RAILS_ENV=#{rails_env} assets:precompile"
  end
end

set :shared_assets, %w{privateconfig privatefiles}

namespace :assets  do
  namespace :symlinks do
    desc "Setup application symlinks for shared assets"
    task :setup, :roles => [:app, :web] do
      shared_assets.each { |link| run "mkdir -p #{shared_path}/#{link}" }
      run "mkdir -p #{shared_path}/assets"
    end

    desc "Link assets for current deploy to the shared location"
    task :update, :roles => [:app, :web] do
      shared_assets.each { |link| run "ln -nfs #{shared_path}/#{link} #{release_path}/#{link}" }
    end
  end
end

before "deploy:setup" do
  assets.symlinks.setup
end

before "deploy:create_symlink" do
  assets.symlinks.update
end
