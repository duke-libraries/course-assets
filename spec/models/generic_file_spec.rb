require 'spec_helper'

describe GenericFile do
  
  context "collectible" do
    
    it "should be assignable to a collection" do
      expect(subject).to respond_to(:collections)
    end
    
  end
  
end