require 'net-ldap'

class DirectoryController < ApplicationController

  def index
    respond_to do |format|
      format.json { render json: search_results }
    end
  end

  protected

  def query
    params[:q]
  end

  def search_results
    client.search(filter: filter).each_with_object([]) do |result, memo|
      memo << attributes.each_with_object({}) { |attr, h| h[attr] = result[attr].first }
    end
  end

  def attributes
    %w(uid edupersonprincipalname displayname title)
  end

  def filter
    Net::LDAP::Filter.contains("cn", query)
  end

  def client
    @client ||= Net::LDAP.new(CourseAssets.directory_conf)
  end

end
