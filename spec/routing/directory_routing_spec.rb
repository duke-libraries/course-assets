require 'spec_helper'

describe "LDAP router" do
  it "should have a search route" do
    expect(get: '/directory').to route_to(controller: "directory", action: "index")
  end
end
