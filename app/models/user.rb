class User < ActiveRecord::Base

  include Hydra::User
  include Sufia::User

  attr_accessible :username, :email, :password, :password_confirmation if Rails::VERSION::MAJOR < 4

  # Connects this user object to Blacklights Bookmarks. 
  include Blacklight::User

  validates_uniqueness_of :username, :case_sensitive => false
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :remote_user_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def to_s
    user_key
  end

end
