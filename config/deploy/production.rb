task :production do
	set :rails_env, 'production'
	set :branch, 'production'

	role :web,  
	role :db, , :primary => true
	role :app, , :migrations => true, :primary => true
  
end