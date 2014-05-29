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

    desc "List proxies for all users or for user specified by FOR=<NetId>"
    task 'proxy_list' => :environment do
      if ENV['FOR']
        proxy_for = ENV['FOR'].include?("@") ? ENV['FOR'] : "#{ENV['FOR']}@duke.edu"
      end
      begin
        list = CourseAssets::Services::ProxyService.list(proxy_for)
        list.each do |entry|
          puts
          puts "User: #{entry[:user].display_name} (#{entry[:user].user_key})"
          puts "Proxies:"
          entry[:proxies].each do |proxy|
            puts "\t#{proxy.display_name} (#{proxy.user_key})"
          end
        end
        puts
      rescue ArgumentError => e
        puts e.message
      end
    end
  
    desc "Add proxy (specified by PROXY=<NetID>) for user (specified by FOR=<NetID>)"
    task 'proxy_add' => :environment do
      raise "Must specify Net ID of user FOR whom proxy is to be added.  Ex.: FOR=abc11" unless ENV['FOR']      
      raise "Must specify Net ID of PROXY to be added.  Ex.: PROXY=xyz89" unless ENV['PROXY']
      proxy_for = ENV['FOR'].include?("@") ? ENV['FOR'] : "#{ENV['FOR']}@duke.edu"
      proxy = ENV['PROXY'].include?("@") ? ENV['PROXY'] : "#{ENV['PROXY']}@duke.edu"
      begin
        result = CourseAssets::Services::ProxyService.add(proxy_for, proxy)
        case result
        when true
          puts "Proxy #{ENV['PROXY']} added to User #{ENV['FOR']}"
        when false
          puts "#{ENV['PROXY']} is already a Proxy for User #{ENV['FOR']}"
        end
      rescue ArgumentError => e
        puts e.message
      end    
    end

    desc "Remove proxy (specified by PROXY=<NetID>) from user (specified by FOR=<NetID>)"
    task 'proxy_remove' => :environment do
      raise "Must specify Net ID of user FOR whom proxy is to be removed.  Ex.: FOR=abc11" unless ENV['FOR']      
      raise "Must specify Net ID of PROXY to be removed.  Ex.: PROXY=xyz89" unless ENV['PROXY']
      proxy_for = ENV['FOR'].include?("@") ? ENV['FOR'] : "#{ENV['FOR']}@duke.edu"
      proxy = ENV['PROXY'].include?("@") ? ENV['PROXY'] : "#{ENV['PROXY']}@duke.edu"
      begin
        result = CourseAssets::Services::ProxyService.remove(proxy_for, proxy)
        case result
        when true
          puts "Proxy #{ENV['PROXY']} removed from User #{ENV['FOR']}"
        when false
          puts "#{ENV['PROXY']} is not a Proxy for User #{ENV['FOR']}"
        end
      rescue ArgumentError => e
        puts e.message
      end    
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

  namespace 'users' do
  end

end