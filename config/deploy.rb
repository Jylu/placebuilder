set :repository, "file:///home/deploy/commonplace.git"
set :local_repository, "git+ssh://commonplace.in/home/deploy/commonplace.git"
set :scm, :git
set :branch, 'master'
set :deploy_via, :checkout
set :use_sudo, false
set :rails_env, "production"
set :default_stage, "staging"

default_run_options[:pty] = true

after 'deploy:update_code', 'deploy:symlink_db'
after 'deploy:symlink_db', 'deploy:symlink_config'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task(:restart, #:roles => :app, 
       :except => { :no_release => true }) do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
  desc "Symlinks the config.yml"
  task :symlink_config, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/config.yml #{release_path}/config/config.yml"
  end
end


namespace :sass do
  desc 'Updates the stylesheets generated by Sass'
  task :update, :roles => :app do
    invoke_command "cd #{latest_release}; RAILS_ENV=#{rails_env} rake sass:update"
  end

  # Generate all the stylesheets manually (from their Sass templates) before each restart.
  before 'deploy:restart', 'sass:update'
end
