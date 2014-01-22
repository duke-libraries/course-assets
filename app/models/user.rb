class User < ActiveRecord::Base

  include Hydra::User
  include Sufia::User

  attr_accessible :email, :password, :password_confirmation if Rails::VERSION::MAJOR < 4

  # Connects this user object to Blacklights Bookmarks. 
  include Blacklight::User

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :remote_user_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def to_s
    user_key
  end

end
