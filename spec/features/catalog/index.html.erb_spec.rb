require 'spec_helper'

describe "catalog/index.html.erb", type: :feature do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @routes = Sufia::Engine.routes
    AlertMessage.destroy_all
    login_as user
  end
  after { Warden.test_reset! }
  
  context "alert message" do
    let(:alert_message) { "This is a test alert message" }
    context "no active alert messages" do
      before { AlertMessage.create(message: alert_message, active: false) }
      it "should not display the alert message" do
        visit "/"
        expect(page).to_not have_text(alert_message)
      end
    end
    context "one active alert message" do
      before { AlertMessage.create(message: alert_message, active: true) }
      it "should display the alert message" do
        visit "/"
        expect(page).to have_text(alert_message)
      end
    end
    context "more than one active alert message" do
      before do
        AlertMessage.create(message: alert_message, active: true)
        AlertMessage.create(message: "Second alert message", active: true)
      end
      it "should display the alert message" do
        visit "/"
        expect(page).to have_text(alert_message)
        expect(page).to have_text("Second alert message")
      end
    end
  end
  
end