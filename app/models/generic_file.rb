class GenericFile < ActiveFedora::Base

  include Sufia::GenericFile
  include Hydra::Collections::Collectible
  
  has_attributes :proxy_depositor, :on_behalf_of, :datastream=>:properties, :multiple => false
  has_attributes :course, datastream: :properties, multiple: true

  after_create :create_transfer_request

  attr_accessible *(ds_specs['descMetadata'][:type].fields + [:permissions, :course])

  def create_transfer_request
    Sufia.queue.push(CourseAssets::Jobs::ContentDepositorChangeEventJob.new(pid, on_behalf_of)) if on_behalf_of.present?
  end
  
  def terms_for_display
    terms = super
    terms.unshift :course
    terms
  end

  def to_solr(solr_doc={}, opts={})
    super(solr_doc, opts)
    index_collection_pids(solr_doc)
    return solr_doc
  end

end
