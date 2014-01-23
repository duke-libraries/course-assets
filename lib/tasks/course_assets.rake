namespace 'course_assets' do

  namespace 'config' do

    desc "Copy sample config files" 
	task 'samples' do
	  sh "cp config/solr.yml.sample config/solr.yml"
      sh "cp config/fedora.yml.sample config/fedora.yml"
      sh "cp config/role_map_test.yml.sample config/role_map_test.yml"
      sh "cp config/environments/test.rb.sample config/environments/test.rb"
      sh "cp config/database.yml.sample config/database.yml"
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
	task 'prepare' => ['course_assets:config:samples', 'db:migrate', 'db:test:prepare', 'jetty:clean', 'jetty:config'] do
	end

  end

end