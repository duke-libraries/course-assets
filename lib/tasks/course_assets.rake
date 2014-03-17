namespace 'course_assets' do

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