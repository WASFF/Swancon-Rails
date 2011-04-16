require "bundler/capistrano"

set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ree-1.8.7-2011.03/bin:/usr/local/rvm/bin:$PATH",
  'RUBY_VERSION' => 'ruby 1.8.7',
  'GEM_HOME'     => '/usr/local/rvm/gems/ree-1.8.7-2011.03',
  'GEM_PATH'     => '/usr/local/rvm/gems/ree-1.8.7-2011.03',
  'BUNDLE_PATH'  => '/usr/local/rvm/gems/ree-1.8.7-2011.03'  # If you are using bundler.
}

set :application, "Swancon Rails App"
set :repository,  "git@github.com:lordmortis/Swancon-Rails.git"
set :user, 'wasff'
set :default_shell, 'bash'
set :rake, 'rake'

set :scm, :git
#set :git_enable_submodules, 1 # if you have vendored rails
set :branch, "master"
set :git_shallow_clone, 1
#set :scm_verbose, true
set :use_sudo, false

role :web, "clientweb.sektorseven.net"                          # Your HTTP server, Apache/etc
role :app, "clientweb.sektorseven.net"                          # This may be the same as your `Web` server
role :db,  "clientweb.sektorseven.net", :primary => true # This is where Rails migrations will run

set :deploy_to, "/home/wasff/swanconapp/"
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

set :shared_assets, %w{privateconfig privatefiles}

namespace :assets  do
  namespace :symlinks do
    desc "Setup application symlinks for shared assets"
    task :setup, :roles => [:app, :web] do
      shared_assets.each { |link| run "mkdir -p #{shared_path}/#{link}" }
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

before "deploy:symlink" do
  assets.symlinks.update
end