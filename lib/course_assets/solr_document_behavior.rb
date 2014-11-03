module CourseAssets
  module SolrDocumentBehavior
    def course
      Array(self[Solrizer.solr_name('course')]).first
    end

    def module_number
      Array(self[Solrizer.solr_name('module')]).first
    end
  end
end
