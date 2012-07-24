require 'spec_helper'
require 'rack/test'


set :environment, :test

class MockWarden

  def initialize(new_user)
    @user = new_user
  end

  def authenticated?(sym)
    true
  end

  def user(sym)
    @user
  end
end

describe API do
  include Rack::Test::Methods

  let(:kickoff) { KickOff.new }
  let(:user) { FactoryGirl.create(:user) }

  let(:app) {
    lambda do |env|
      env['kickoff'] = kickoff
      env['warden'] = MockWarden.new(user)
      API.call(env)
    end
  }

  let(:community) { mock_model(Community) }

  shared_examples "A JSON endpoint" do
    it "returns a valid JSON response" do
      lambda {JSON.parse(last_response.body)}.should_not raise_error(JSON::ParserError)
    end
  end

  before do
    stub(User).find_by_authentication_token { true }
    stub(Community).find(community.id.to_s) { community }
  end

  describe "GET /" do
    it "fails" do
      get '/'
      last_response.should_not be_ok
    end
  end

  shared_examples "An API-Resident connector" do |connector|
    subject { JSON.parse(last_response.body) }
    let!(:matching_resident) { FactoryGirl.create(:resident, email: resident_email, first_name: resident_first_name, last_name: resident_last_name) }
    let(:resident_email) { "text@email.com" }
    let(:resident_first_name) { user.first_name }
    let(:resident_last_name) { user.last_name }

    let(:friend_email) { resident_email }
    let(:friend_first_name) { resident_first_name }
    let(:friend_last_name) { resident_last_name }
    let(:facebook_friends) do
      [
        ["#{friend_first_name} #{friend_last_name}", friend_email]
      ]
    end

    let(:login_params) do
      ActiveSupport::JSON.encode({
        'email' => user.email,
        'password' => user.password
      })
    end

    let(:email_account_login_params) do
      {
        'login' => user.email,
        'password' => user.password
      }
    end

    before do
      stub(connector).friends_from_api { facebook_friends } # TODO: WEBMOCK THIS
      post "/sessions/", login_params, {'warden' => MockWarden.new(user) }
      post connector.api_endpoint, email_account_login_params
    end

    context "when the user has no #{connector.service_name} friends that are neighbors" do
      let(:friend_email) { }
      let(:friend_first_name) { }
      let(:friend_last_name) { }
      it { should be_empty }
    end

    context "when the user has a #{connector.service_name} friend that is a neighbor" do
      it { should_not be_empty }
      its(:count) { should == 1 }
    end

  end

  describe "GET /accounts/facebook_neighbors" do
    it_behaves_like "An API-Resident connector", FacebookNeighbors
  end
  describe "GET /accounts/gmail_neighbors" do
    it_behaves_like "An API-Resident connector", GmailNeighbors
  end
end
