$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"                             
set :rvm_ruby_string, 'ruby-1.9.2-p180'              
set :rvm_type, :user

set :application, "scraper"
role :web, "192.168.1.4"

set :user, "gor"
set :use_sudo, false

set :scm, :git
set :deploy_via, :remote_cache
set :scm_user, "gor"
set :repository, "git://gitorious.org/scraper/scraper.git"

set :deploy_to, "/home/#{user}/Projects/#{application}"

default_run_options[:pty] = true
set :restart_method, :nginx
set :rails_env, "production"
set :rake, "$GEM_HOME/bin/rake"
set :bundler, "$GEM_HOME/bin/bundle"

after :deploy, "bundle:install"
after :deploy, "migrate"
after :deploy, "deploy:restart"

namespace :deploy do
  task :restart, :roles => :web, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

task :reseed do
  run "cd #{deploy_to}/current && #{rake} db:migrate:reset && #{rake} db:seed"
end

task :migrate do
  run "cd #{deploy_to}/current && RAILS_ENV=#{rails_env} #{rake} db:migrate"
end

namespace :bundle do
  task :install, :roles => :web, :except => { :no_release => true } do
    run "cd #{deploy_to}/current && #{bundler} install --local --without development test"
  end
end
