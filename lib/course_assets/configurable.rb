module CourseAssets
  module Configurable
    extend ActiveSupport::Concern

    included do
      mattr_accessor :audituser_key
      mattr_accessor :audituser_email
      mattr_accessor :batchuser_key
      mattr_accessor :batchuser_email
      mattr_accessor :directory_conf
    end

    module ClassMethods
      def configure
        yield self
      end
    end

  end
end
