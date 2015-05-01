role :app, %w{sc2015@swancon-mel1.swancon.com.au}
role :web, %w{sc2015@swancon-mel1.swancon.com.au}
role :db,  %w{sc2015@swancon-mel1.swancon.com.au}

set :deploy_to, '/home/sc2014/SwanconRails/production'

set :branch, "sc2015"

set :deploy_to, '/home/sc2015/SwanconRails/production'
set :linked_files, fetch(:base_linked_files) + ["db/production.sqlite3"]

set :linked_dirs, fetch(:base_linked_dirs)
