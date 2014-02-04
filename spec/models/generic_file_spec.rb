require 'spec_helper'

describe GenericFile do
  
  context "collectible" do
    
    it "should be collectible" do
      expect(subject).to be_a(Hydra::Collections::Collectible)
    end
    
  end
  
end