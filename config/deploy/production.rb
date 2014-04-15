role :app, %w{sc2014@swancon-mel1.swancon.com.au}
role :web, %w{sc2014@swancon-mel1.swancon.com.au}
role :db,  %w{sc2014@swancon-mel1.swancon.com.au}

set :deploy_to, '/home/sc2014/SwanconRails/production'

set :branch, :master

set :linked_files, fetch(:base_linked_files) + ["db/production.sqlite3"]
set :linked_dirs, fetch(:base_linked_dirs)
