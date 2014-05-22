default_run_options[:pty] = true
set :application, "Time Record"
set :repository,  "gitolite@10.86.3.1:mint"
set :domain, "10.86.9.155"

set :scm, :git
set :scm_passphrase, "Mbi800716"

set :user, "teamcity"
set :password, "TeamCity123456"

ssh_options[:forward_agent] = true
set :branch, "master"

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

set :deploy_to, "/home/teamcity/www_root/mint/rails"
set :use_sudo, false

namespace :deploy do

  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    command = "if [ -e /tmp/unicorn.metis.pid ]; then \
              #{try_sudo} kill -s QUIT `cat /tmp/unicorn.metis.pid` ; \
              fi;"
    run command
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end

  task :link_config, :roles => :app, :except => { no_release: true } do
    run "cd #{release_path} ; ln -s #{shared_path}/config/database.yml config/database.yml"
  end

end

require 'bundler/capistrano'
# set :bundle_flags, "--deployment --without development test"

after "deploy:update_code", "deploy:migrate"
before "deploy:finalize_update", "deploy:link_config"
# after "deploy:migrate", "deploy:seed"
after "deploy:create_symlink", "deploy:restart"
# after "deploy:restart", "resque:restart"

# require 'rvm/capistrano'
