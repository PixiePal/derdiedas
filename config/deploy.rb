set :application, "derdiedas"
set :scm, :git
set :repository, "git://github.com/PixiePal/derdiedas.git"
set :branch, "master"
set :deploy_to, "/home/fruitcr/derdiedas/"
set :deploy_via, :remote_cache
set :user, "fruitcr"
set :use_sudo, false

role :app, "74.63.10.51"
role :web, "74.63.10.51"
role :db,  "74.63.10.51", :primary => true

task :after_finalize_update, :except => { :no_release => true } do
  configs_for = %w{database}
  commands_todo = configs_for.map { |cfg| "cp #{current_path}/config/#{cfg}.yml #{release_path}/config/#{cfg}.yml"}
  commands_todo << "cp #{current_path}/config/session.secret #{release_path}/config/session.secret"
  run commands_todo.join(" && ")
end

namespace :deploy do
 desc "Restarting mod_rails with restart.txt"
 task :restart, :roles => :app, :except => { :no_release => true } do
   run "touch #{current_path}/tmp/restart.txt"
 end
end


#call with: cap FILE=localfile.txt import:verbs
namespace :import do
 desc "Import verbs from a local file."
 task :time, :roles => :web do
   base_filename = File.basename(ENV['FILE'])
   remote_filename = "#{shared_path}/#{base_filename}"

   p "Uploading file: #{base_filename}"
   put(File.read(ENV['FILE']), remote_filename)
   
   run "cd #{current_path} && RAILS_ENV=production script/runner \"Verb.import_from_txt_file('#{remote_filename}')\""

   p "Removing remote file: #{remote_filename}"
   run("rm -f #{remote_filename}")
 end
end