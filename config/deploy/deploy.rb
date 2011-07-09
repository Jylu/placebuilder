namespace :deploy do
  desc "Deploy the application"
  task :default do
    update
    restart
  end
 
  task :symlink do
  end

  desc "Flush the Rails cache"
  task :flush do
    run "cd #{current_path} ; bundle exec rake cache:clear"
  end

  task :update_code do
    commands = ["cd #{current_path}",
                "git fetch origin",
                "git reset --hard #{branch}",
                "git submodule update --init",
                "bundle exec rake cache:clear RAILS_ENV=#{rails_env}"]
    run commands.join("; ")
  end
  
  namespace :rollback do
    desc "Rollback a single commit."
    task :code do
      set :branch, "HEAD^"
      deploy.default
    end

    task :default do
      rollback.code
    end
  end
end
