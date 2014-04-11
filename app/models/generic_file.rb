class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile
  include Hydra::Collections::Collectible
  
  has_attributes :proxy_depositor, :on_behalf_of, :datastream=>:properties, :multiple => false

  after_create :create_transfer_request

  def create_transfer_request
    Sufia.queue.push(CourseAssets::Jobs::ContentDepositorChangeEventJob.new(pid, on_behalf_of)) if on_behalf_of.present?
  end
  
  def to_solr(solr_doc={}, opts={})
    super(solr_doc, opts)
    index_collection_pids(solr_doc)
    return solr_doc
  end

end