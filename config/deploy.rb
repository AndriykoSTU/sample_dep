# config valid only for current version of Capistrano
lock '3.3.5'



set :application, 'sample_dep'
#git@github.com:AndriykoSTU/sample_dep.git
set :repo_url, 'https://AndriykoSTU:deusexmach1na@github.com/AndriykoSTU/sample_dep'
set :user, 'deployer'
set :linked_files, %w{config/database.yml}
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

#set :tmp_dir, 'home/deployer/tmp'


    set :copy_remote_dir, deploy_to

set :use_sudo,         false
set :rvm_type,         :user
set :rvm_ruby_version, '2.1.3'
set :rvm_custom_path,  '/home/deployer/.rvm'
set :stage,     :production
set :branch,    'master'
set :deploy_to, '/home/deployer/sample_dep'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
set :scm, :git




# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []

# Default value for linked_dirs is []

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5




namespace :deploy do

    desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end
end

namespace :unicorn do
  pid_path = "#{release_path}/tmp/pids"
  unicorn_pid = "#{pid_path}/unicorn.pid"

  def run_unicorn
    execute "#{fetch(:bundle_binstubs)}/unicorn", "-c #{release_path}/config/unicorn.rb -D -E #{fetch(:stage)}"
  end

  desc 'Start unicorn'
  task :start do
    on roles(:app) do
      run_unicorn
    end
  end

  desc 'Stop unicorn'
  task :stop do
    on roles(:app) do
      if test "[ -f #{unicorn_pid} ]"
        execute :kill, "-QUIT `cat #{unicorn_pid}`"
      end
    end
  end

  desc 'Force stop unicorn (kill -9)'
  task :force_stop do
    on roles(:app) do
      if test "[ -f #{unicorn_pid} ]"
        execute :kill, "-9 `cat #{unicorn_pid}`"
        execute :rm, unicorn_pid
      end
    end
  end

  desc 'Restart unicorn'
  task :restart do
    on roles(:app) do
      if test "[ -f #{unicorn_pid} ]"
        execute :kill, "-USR2 `cat #{unicorn_pid}`"
      else
        run_unicorn
      end
    end
  end

end
