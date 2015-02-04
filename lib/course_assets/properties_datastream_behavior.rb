module CourseAssets
  module PropertiesDatastreamBehavior
    extend ActiveSupport::Concern

    included do
      extend_terminology do |t|
          t.course index_as: [:stored_searchable, :facetable]
          t.module index_as: [:stored_searchable, :facetable]
      end
    end

  end
end