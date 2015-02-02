require 'fileutils'

class GenericFile < ActiveFedora::Base

  include Sufia::GenericFile
  
  has_attributes :course, :module, datastream: :properties, multiple: true
  has_file_datastream 'content', type: FileContentDatastream, control_group: 'E'

  around_destroy :delete_external_files

  attr_accessible *(ds_specs['descMetadata'][:type].fields + [:permissions, :course, :module])

  CHUNK = 1024**2

  def terms_for_display
    terms = super
    terms.unshift :course, :module
    terms
  end

  # Overridden to write the file into the external store instead of a datastream
  def add_file(file, dsid, file_name) 
    return add_external_file(file, file_name) if dsid == 'content'
    super
  end

  def add_external_file(file, file_name)
    content.dsLocation = write_to_external_datastore file, file_name
    mime = MIME::Types.type_for(file_name).first
    content.mimeType = mime.content_type if mime # mime can't always be detected by filename
    set_title_and_label file_name, only_if_blank: true
  end

  private

  def delete_external_files
    file_paths = {}
    datastreams.each do |dsid, ds|
      if ds.controlGroup == 'E'
        file_paths[dsid] = ds.versions.map { |v| URI::parse(v.dsLocation).path }
      end
    end
    yield
    file_paths.each do |dsid, ds_file_paths|
      ds_file_paths.each { |fp| File.delete(fp) }
    end
  end

  # Returns URI to file in external datastore
  def write_to_external_datastore file, file_name
    external_file_path = File.join external_file_dirname, file_name

    if file.respond_to? :read
      File.open(external_file_path, "wb") do |f|
        f.write(file.read(CHUNK)) until file.eof?
        file.rewind
      end
    elsif File.exists? file # raises TypeError
      FileUtils.mv file, external_file_path
    else
      raise ArgumentError, "File not found: #{file.inspect}"
    end

    external_file_uri external_file_path
  end

  def external_file_uri path
    URI.escape "file://#{path}"
  end

  # Generates a directory name from a new UUID
  #
  # Example:
  #
  # UUID: 1e691815-0631-4f9b-8e23-2dfb2eec9c70
  #
  # Directory: {BASE}/1/e/69/1e691815-0631-4f9b-8e23-2dfb2eec9c70
  #
  def external_file_dirname
    dirbase = external_file_dirbase
    dirname = File.join CourseAssets.external_datastore_base, dirbase[0], dirbase[1], dirbase[2,2], dirbase
    FileUtils.mkdir_p(dirname).first
  end

  def external_file_dirbase
    SecureRandom.uuid
  end

end
