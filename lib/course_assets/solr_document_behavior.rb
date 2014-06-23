module CourseAssets
  module SolrDocumentBehavior
    def course
      Array(self[Solrizer.solr_name('course')]).first
    end
  end
end