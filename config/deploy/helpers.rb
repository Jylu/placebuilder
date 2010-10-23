def set(*args)
  if args.first == :web_server
    lib_path = File.dirname(__FILE__)
    load "#{lib_path}/#{args.last.to_s}.rb"
  end
  super(*args)
end

def value(setting, default = nil)
  if respond_to?(setting) && !send(setting).nil?
    send(setting)
  else
    default
  end
end

def run(cmd, options = {}, &block)
  options.merge!(:env => { "PATH" => "#{ruby_path}:$PATH" }) if value(:ruby_path)
  super(cmd, options, &block)
end

def sudo_put(data, target)
  tmp = "#{shared_path}/~tmp-#{rand(9999999)}"
  put data, tmp
  on_rollback { run "rm #{tmp}" }
  sudo "cp -f #{tmp} #{target} && rm #{tmp}"
end

namespace :sass do
  desc 'Updates the stylesheets generated by Sass'
  task :update, :roles => :app do
    run("cd #{current_path} && #{bin_path}/rake sass:update RAILS_ENV=#{rails_env}")
  end

  # Generate all the stylesheets manually (from their Sass templates) before each restart.
  before 'deploy:restart', 'sass:update'
end

namespace :resque do
  desc "Restarts resque workers"
  task :restart, :roles => :app do
    sudo("#{bin_path}/god restart resque-workers")
  end

  after 'deploy:restart', 'resque:restart'
end
