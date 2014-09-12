FactoryGirl.define do

  factory :generic_file do
    title "Test File"
    creator "Awesome Dude"
    tag %w(rocks clouds grass birds)
    before(:create) do |gf|
      gf.apply_depositor_metadata create(:user)
    end
  end

end
