require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain           - The hostname to SSH to.
#   deploy_to        - Path to deploy into.
#   repository       - Git repo to clone from. (needed by mina/git)
#   branch           - Branch name to deploy. (needed by mina/git)
#   secret_key_name  - Set Secret ENV name
#   secret_key_pass  - Set Secret ENV password

# Order of operation 1st time setup:
#  mina setup
#  mina set_bash
#  mina config_copy
#  setup nginx with correct gemset if necessary
#  mina deploy

set :domain, 'dot'
set :deploy_to, '/var/www/tricho-fl'
set :repository, 'git@github.com:staycreativedesign/tricho-fl.git'
set :branch, 'master'
# set :secret_key_name, 'VIVE_SECRET_KEY_BASE'
# set :secret_key_pass, '6ad0be6bc44aa3c0d9b2751557e0cd2f46854932f0c4f5b0c21b5ae41844804c1f4721d7c006b654d67e3d48f094f5ecee62c6a53717e287f41a35b360d7cce3'
set :db_name_env, 'TRICHO_DB'
set :db_name, 'tricho_production'
set :db_user_name_env, 'TRICHO_USER'
set :db_user_name, 'tricho_admin'
set :db_user_pass_env, 'TRICHO_DB_USER_PASS'
set :db_user_pass, 'JMd[5aw!Sx(2'

set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log']
set :term_mode, :pretty
set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
   invoke :'rvm:use[ruby-2.3.1@global]'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/public/uploads"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/public/uploads"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml' and 'secrets.yml'."]

  if repository
    repo_host = repository.split(%r{@|://}).last.split(%r{:|\/}).first
    repo_port = /:([0-9]+)/.match(repository) && /:([0-9]+)/.match(repository)[1] || '22'

    queue %[
      if ! ssh-keygen -H  -F #{repo_host} &>/dev/null; then
        ssh-keyscan -t rsa -p #{repo_port} -H #{repo_host} >> ~/.ssh/known_hosts
      fi
    ]
  end
end

desc "Add Enviroment Variable to bash_profile"
task :set_bash => :environment do
  # Set Enviromental Variable for Production
  # queue! %[echo '#{secret_key_name}="#{secret_key_pass}"' >> ~/.bash_profile]
  queue! %[echo '#{db_name_env}="#{db_name}"' >> ~/.bash_profile]
  queue! %[echo '#{db_user_name_env}="#{db_user_name}"' >> ~/.bash_profile]
  queue! %[echo '#{db_user_name_pass_env}="#{db_user_pass}"' >> ~/.bash_profile]
  queue! %[source ~/.bash_profile]
end

desc 'Copy local database and secret files to server'
task :config_copy do
  system "scp config/secrets.yml dot:/var/www/vive/shared/config"
  system "scp config/database.yml dot:/var/www/vive/shared/config"
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    queue! %[gem install bundler]
    # queue! %[rvm install ruby-2.2.1]
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    end
  end
end
