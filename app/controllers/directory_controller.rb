class DirectoryController < ApplicationController

  def user
    ds = DirectoryService.new
    un = params[:uid].gsub(/-dot-/, '.')
    result = ds.find_by_uid(un.split('@').first)
    render :json => result ? [un] : []
  end

  # Stub method.  Override this in your application if you want directory lookups
  def user_attribute
    # if params[:attribute] == "groups"
    #   res = User.groups(params[:uid])
    # else
    #   res = User.directory_attributes(params[:uid], params[:attribute])
    # end
    # render :json => res
    render :json => "" 
  end

  # Stub method.  Override this in your application if you want directory lookups
  def user_groups
    # render :json => User.groups(params[:uid])
    render :json => [] 
  end

  # Stub method.  Override this in your application if you want directory lookups
  def group
    #render :json => Group.exists?(params[:cn])
    render :json => false 
  end
end
