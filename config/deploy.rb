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

set :assets_dependencies, %w(app/assets lib/assets vendor/assets Gemfile.lock config/routes.rb)

namespace :deploy do

  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    command = "if [ -e #{shared_path}/tmp/pids/unicorn.mint.pid ]; then \
              #{try_sudo} kill -s QUIT `cat #{shared_path}/tmp/pids/unicorn.mint.pid` ; \
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

  # namespace :assets do

  #   desc <<-DESC
  #     Run the asset precompilation rake task. You can specify the full path \
  #     to the rake executable by setting the rake variable. You can also \
  #     specify additional environment variables to pass to rake via the \
  #     asset_env variable. The defaults are:

  #       set :rake,      "rake"
  #       set :rails_env, "production"
  #       set :asset_env, "RAILS_GROUPS=assets"
  #       set :assets_dependencies, fetch(:assets_dependencies) + %w(config/locales/js)
  #   DESC
  #   task :precompile, :roles => :web, :except => { :no_release => true } do
  #     from = source.next_revision(current_revision)
  #     if capture("cd #{latest_release} && #{source.local.log(from)} #{assets_dependencies.join ' '} | wc -l").to_i > 0
  #       run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
  #     else
  #       logger.info "Skipping asset pre-compilation because there were no asset changes"
  #     end
  #   end

  # end

end

require 'bundler/capistrano'
# set :bundle_flags, "--deployment --without development test"

after "deploy:update_code", "deploy:migrate"
before "deploy:finalize_update", "deploy:link_config"
# after "deploy:migrate", "deploy:seed"
after "deploy:create_symlink", "deploy:restart"
# after "deploy:restart", "resque:restart"

# require 'rvm/capistrano'
