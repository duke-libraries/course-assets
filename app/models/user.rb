require 'directory_service'

class User < ActiveRecord::Base

  include Hydra::User
  include Sufia::User
  include Sufia::UserUsageStats

  attr_accessible :username, :email, :password, :password_confirmation if Rails::VERSION::MAJOR < 4

  # Connects this user object to Blacklights Bookmarks. 
  include Blacklight::User

  validates_uniqueness_of :username, :case_sensitive => false
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :remote_user_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :deposit_rights_given, foreign_key: 'grantor_id', class_name: 'ProxyDepositRights', dependent: :destroy
  has_many :can_receive_deposits_from, through: :deposit_rights_given, source: :grantee

  has_many :deposit_rights_received, foreign_key: 'grantee_id', class_name: 'ProxyDepositRights', dependent: :destroy
  has_many :can_make_deposits_for, through: :deposit_rights_received, source: :grantor

  def to_s
    display_name || user_key
  end
  
  def inverted_name
    i_name = ""
    if last_name.present?
      i_name << last_name << ", "
    end
    i_name << first_name if first_name.present?
    if middle_name.present?
      i_name << " " << middle_name
    end
    i_name.strip.squeeze(" ")
  end

  def directory
    File.join(CourseAssets.local_ingest_base, netid)
  end

  def files
    filelist = []
    entries = Dir.glob("#{directory}/**/*")
    entries.each do |entry|
      filename = entry.sub(File.join(directory, "/"), "")
      filelist << { name: filename, directory: File.directory?(entry)} unless File.directory?(entry)
    end
    filelist
  end

  def self.audituser
    User.find_by_user_key(audituser_key) || User.create!(Devise.authentication_keys.first => audituser_key, password: Devise.friendly_token[0,20], email: audituser_email)
  end  

  def self.audituser_key
    CourseAssets.audituser_key
  end

  def self.audituser_email
    CourseAssets.audituser_email
  end

  def self.batchuser
    User.find_by_user_key(batchuser_key) || User.create!(Devise.authentication_keys.first => batchuser_key, password: Devise.friendly_token[0,20], email: batchuser_email)
  end  

  def self.batchuser_key
    CourseAssets.batchuser_key
  end

  def self.batchuser_email
    CourseAssets.batchuser_email
  end

  # Create a new user based on NetID
  # Returns false if user exists in local db,
  # or if not found in the directory
  # or unable to persist;
  # otherwise, returns created user.
  def self.create_by_netid(netid)
    username = "#{netid}@duke.edu"
    user = User.find_by_username(username)
    if user
      puts "User #{user} exists" 
      return false
    end
    ds = DirectoryService.new
    ds_result = ds.find_by_edupersonprincipalname(username)
    unless ds_result.nil?
      user = User.new.tap do |u|
        u.username = username
        password = SecureRandom.hex(16)
        u.password = password
        u.password_confirmation = password
        u.update_directory_attributes(ds_result)
      end
      if user.persisted?
        puts "New user created: #{user}"
        return user
      else
        puts "Unable to create new user: #{user}"
        return false
      end
    else
      puts "#{username} not found in the directory"
      return false
    end
  end

  # Update all users from the directory service
  def self.update_all_from_directory
    DirectoryService.new do |ds|
      User.find_each do |u| 
        next if [batchuser_key, audituser_key].include? u.user_key
        ds_result = ds.find_by_edupersonprincipalname(u.username)
        if ds_result
          if u.update_directory_attributes ds_result
            puts "#{u} updated"
          else
            puts "#{u} NOT updated!"
          end
        else
          puts "#{u} not found in the directory"
        end
      end
    end
  end

  # Update user attributes from DirectoryService::Result instance
  def update_directory_attributes(result)
    attrs_to_update = {}
    CourseAssets.user_attribute_map.each do |k, v|
      value = result.first_value(v.downcase)
      attrs_to_update[k] = value if value
    end
    update attrs_to_update
  end

  private

  def netid
    user_key.split("@").first
  end

end
