namespace 'course_assets' do

  namespace 'users' do

    desc "Update directory attributes for all users"
    task :update_all => :environment do
	  User.update_all_from_directory
	end

    desc "Update attributes if user exists; otherwise create new user"
	task :create => :environment do
	  raise "Must specify user's NetID, e.g. NETID=foo" unless ENV['NETID']
	  u = User.create_by_netid ENV['NETID']
	end

  end

  namespace 'config' do

    desc "Copy sample config files" 
	task 'samples' do
	  Dir.chdir("config") do
	    Dir.glob("*.sample") do |sample|
		  actual = sample.gsub(/\.sample/, "")
		  FileUtils.cp sample, actual, verbose: true unless File.exists?(actual)
		end
	  end
	end
  end

  namespace 'ci' do

    desc "Run CI build"
	task 'build' => 'prepare' do
	  ENV['environment'] = "test"
	  jetty_params = Jettywrapper.load_config
  	  jetty_params[:startup_wait] = 60
      Jettywrapper.wrap(jetty_params) do
        Rake::Task['spec'].invoke
	  end
	end

    desc "Prepare for CI build"
	task 'prepare' => ['course_assets:config:samples', 'db:create', 'jetty:clean', 'jetty:config'] do
	end

  end

end