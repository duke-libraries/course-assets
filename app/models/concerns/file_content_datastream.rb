class FileContentDatastream < ActiveFedora::Datastream

  include Hydra::Derivatives::ExtractMetadata
  include Sufia::FileContent::Versions

  def filename
    URI.unescape(dsLocation).sub('file://', '') if dsLocation
  end

  # Override so that we can use external files.
  def has_content?
    dsLocation.present? && File.exists?(filename)
  end

  # Override so that we can use external files.
  def to_tempfile &block
    return unless has_content?
    yield File.open(filename, 'rb')
  end

end
