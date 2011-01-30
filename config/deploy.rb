set :application, "TorrentScraper"

set :scm, :git
set :deploy_via, :remote_cache
set :scm_user, "gor"
set :repository, "git://gitorious.org/scraper/scraper.git"

set :restart_method, :nginx

role :web, "192.168.1.4"

default_run_options[:pty] = true
ssh_options[:port] = 7465
set :rails_env, "production"

set :user, "gor"
set :use_sudo, false

set :deploy_to, "/home/#{user}/#{application}"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
#

namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after :deploy, "passenger:restart"

namespace :deploy do
  task :restart, :roles => :web, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :reseed, :roles => :web, :except => { :no_release => true } do
    run "RAILS_ENV=\"production\" cd #{deploy_to}/current && rake db:migrate:reset && rake db:seed"
  end
end
