require 'spec_helper'

describe GenericFile do
  
  context "collectible" do
    
    let(:collection) { Collection.new }
    
    before { subject.collections << collection }
    
    it "should be assignable to a collection" do
      expect(subject.collections).to include(collection)
    end
    
  end
  
end