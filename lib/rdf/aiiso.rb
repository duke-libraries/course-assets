module RDF
  ##
  # Academic Institution Internal Structure Ontology (AIISO)
  # @see http://purl.org/vocab/aiiso/schema#
  class AIISO < RDF::StrictVocabulary("http://purl.org/vocab/aiiso/schema#")
    # classes
    property :Center
    property :College
    property :Course
    property :Department
    property :Division
    property :Faculty
    property :Institute
    property :Institution
    property :KnowledgeGrouping
    property :Module
    property :Programme
    property :ResearchGroup
    property :School
    property :Subject
    # property :organizationalUnit # deprecated
    # properties
    property :code
    property :description
    property :knowledgeGrouping
    # property :name # deprecated
    property :organization
    # property :organizationalUnit # deprecated
    property :part_of
    property :responsbilityOf
    property :responsibleFor
    property :teaches
  end
end