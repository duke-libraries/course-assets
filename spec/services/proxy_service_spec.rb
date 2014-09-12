require 'spec_helper'

describe CourseAssets::Services::ProxyService do
  
  let(:proxy_service) { CourseAssets::Services::ProxyService }
  let(:userA) { FactoryGirl.create(:user) }
  let(:userB) { FactoryGirl.create(:user) }
  let(:userC) { FactoryGirl.create(:user) }
  let(:missing_user_error_message) { I18n.t("course_assets.argument_missing", argument: "user") }
  let(:missing_proxy_error_message) { I18n.t("course_assets.argument_missing", argument: "proxy") }
  let(:unknown_user_key) { "non-existent-user-key" }
  let(:unknown_user_error_message) { I18n.t("course_assets.user_not_found", user_key: unknown_user_key) }

  before do
    userA.can_receive_deposits_from << userB
    userA.can_receive_deposits_from << userC
    userA.save!
    userB.can_receive_deposits_from << userC
    userB.save!
  end
  
  describe "#list" do
    context "no user given" do
      let(:results) { [ { user: userA, proxies: [ userB, userC ] }, { user: userB, proxies: [ userC ] } ] }
      it "should list all users with a proxy and their proxies" do
        expect(proxy_service.list).to match_array(results)
      end
    end
    context "user given" do
      context "user key given" do
        context "user exists" do
          context "user has proxies" do
            let(:results) { [ { user: userA, proxies: [ userB, userC ] } ] }
            it "should list the proxies for that user" do
              expect(proxy_service.list(userA.user_key)).to match_array(results)
            end
          end
          context "user has no proxies" do
            let(:results) { [ { user: userC, proxies: [ ] } ] }
            it "should list no proxies for that user" do
              expect(proxy_service.list(userC.user_key)).to match_array(results)
            end        
          end
        end
        context "user does not exist" do
          it "should raise an exception" do
            expect { proxy_service.list(unknown_user_key) }.to raise_error(ArgumentError, unknown_user_error_message)
          end
        end
      end
      context "user object given" do
        context "user has proxies" do
          let(:results) { [ { user: userA, proxies: [ userB, userC ] } ] }
          it "should list the proxies for that user" do
            expect(proxy_service.list(userA)).to match_array(results)
          end
        end
        context "user has no proxies" do
          let(:results) { [ { user: userC, proxies: [ ] } ] }
          it "should list no proxies for that user" do
            expect(proxy_service.list(userC)).to match_array(results)
          end        
        end
      end
    end
  end
  
  describe "#add" do
    context "arguments missing" do
      context "user missing" do
        it "should raise an exception" do
          expect { proxy_service.add(nil, userA) }.to raise_error(ArgumentError, missing_user_error_message)
        end
      end
      context "proxy missing" do
        it "should raise an exception" do
          expect { proxy_service.add(userA, nil) }.to raise_error(ArgumentError, missing_proxy_error_message)
        end
      end
    end
    context "arguments present" do
      context "users exist" do
        context "proxy is not already a proxy for the user" do
          let(:proxies) { [ userA, userC ] }
          context "arguments are user keys" do
            it "should add the proxy to the proxy list for the user" do
              expect(proxy_service.add(userB.user_key, userA.user_key)).to be(true)
              expect(userB.reload.can_receive_deposits_from).to match_array(proxies)
            end
          end
          context "arguments are users" do
            it "should add the proxy to the proxy list for the user" do
              expect(proxy_service.add(userB, userA)).to be(true)
              expect(userB.reload.can_receive_deposits_from).to match_array(proxies)
            end
          end
        end
        context "proxy is already a proxy for the user" do
          let(:proxies) { [ userC ] }
          context "arguments are user keys" do
            it "should not re-add the proxy to the proxy list for the user" do
              expect(proxy_service.add(userB.user_key, userC.user_key)).to be(false)
              expect(userB.reload.can_receive_deposits_from).to match_array(proxies)
            end
          end
          context "arguments are users" do
            it "should not re-add the proxy to the proxy list for the user" do
              expect(proxy_service.add(userB, userC)).to be(false)
              expect(userB.reload.can_receive_deposits_from).to match_array(proxies)
            end
          end          
        end
      end
      context "user does not exist" do
        context "proxied user does not exist" do
          context "arguments are user keys" do
            it "should raise an exception" do
              expect { proxy_service.add(unknown_user_key, userA.user_key) }.to raise_error(ArgumentError, unknown_user_error_message)
            end
          end
        end
        context "proxy user does not exist" do
          context "arguments are user keys" do
            it "should raise an exception" do
              expect { proxy_service.add(userA.user_key, unknown_user_key) }.to raise_error(ArgumentError, unknown_user_error_message)
            end
          end
        end
      end
    end
  end
  
  describe "#remove" do
    context "arguments missing" do
      context "user missing" do
        it "should raise an exception" do
          expect { proxy_service.remove(nil, userA) }.to raise_error(ArgumentError, missing_user_error_message)
        end
      end
      context "proxy missing" do
        it "should raise an exception" do
          expect { proxy_service.remove(userA, nil) }.to raise_error(ArgumentError, missing_proxy_error_message)
        end
      end
    end
    context "arguments present" do
      context "users exist" do
        context "proxy is a proxy for the user" do
          let(:proxies) { [ userC ] }
          context "arguments are user keys" do
            # before { proxy_service.remove(userA.user_key, userB.user_key) }
            it "should remove the proxy to the proxy list for the user" do
              expect(proxy_service.remove(userA.user_key, userB.user_key)).to be(true)
              expect(userA.reload.can_receive_deposits_from).to match_array(proxies)
            end
          end
          context "arguments are users" do
            it "should remove the proxy to the proxy list for the user" do
              expect(proxy_service.remove(userA, userB)).to be(true)
              expect(userA.reload.can_receive_deposits_from).to match_array(proxies)
            end
          end
        end
        context "proxy is not a proxy for the user" do
          let(:proxies) { [ userC ] }
          context "arguments are user keys" do
            it "should not alter the proxy list for the user" do
              expect(proxy_service.remove(userB.user_key, userA.user_key)).to be(false)
              expect(userB.reload.can_receive_deposits_from).to match_array(proxies)
            end
          end
          context "arguments are users" do
            it "should not alter the proxy list for the user" do
              expect(proxy_service.remove(userB, userA)).to be(false)
              expect(userB.reload.can_receive_deposits_from).to match_array(proxies)
            end
          end          
        end
      end
      context "user does not exist" do
        context "proxied user does not exist" do
          context "arguments are user keys" do
            it "should raise an exception" do
              expect { proxy_service.remove(unknown_user_key, userA.user_key) }.to raise_error(ArgumentError, unknown_user_error_message)
            end
          end
        end
        context "proxy user does not exist" do
          context "arguments are user keys" do
            it "should raise an exception" do
              expect { proxy_service.remove(userA.user_key, unknown_user_key) }.to raise_error(ArgumentError, unknown_user_error_message)
            end
          end
        end
      end
    end
  end

end