set :application, "TorrentScraper"
role :web, "192.168.1.4"

set :user, "gor"
set :use_sudo, false

set :scm, :git
set :deploy_via, :remote_cache
set :scm_user, "gor"
set :repository, "git://gitorious.org/scraper/scraper.git"

set :deploy_to, "/home/#{user}/#{application}"

default_run_options[:pty] = true
ssh_options[:port] = 7465
set :restart_method, :nginx
set :rails_env, "production"
set :rake, "$GEM_HOME/bin/rake"
set :bundle, "$GEM_HOME/bin/bundle"

after :deploy, :create_cron_task
after :deploy, "deploy:restart"

namespace :deploy do
  task :restart, :roles => :web, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

task :reseed do
  run "cd #{deploy_to}/current && #{rake} db:migrate:reset && #{rake} db:seed"
end

namespace :bundle do
  task :install, :roles => :web, :except => { :no_release => true } do
    run "cd #{deploy_to}/current && #{bundle} install"
  end
end

task :create_cron_task do
  run "cd #{current_path} && /home/gor/.rvm/rubies/ruby-1.9.2-p136/bin/ruby /home/gor/.rvm/gems/ruby-1.9.2-p136/bin/whenever -s environment=#{rails_env} -w crontab"
end
