require 'spec_helper'

describe AlertMessage do

  describe "validation" do
    it "should validate the presence of the message attribute" do
      expect(AlertMessage.create(active: true).errors).to have_key(:message)
    end
    it "should validate the presence of the active attribute" do
      expect(AlertMessage.create(message: "Test Message").errors).to have_key(:active)
    end
  end

end