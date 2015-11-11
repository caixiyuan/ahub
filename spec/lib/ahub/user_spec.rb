require 'spec_helper'

describe Ahub::User do
  let(:single_response) do
    {
      id: 7,
      type: "user",
      creationDate: 1416502952553,
      creationDateFormatted: "11/20/2014 12:02 PM",
      modificationDate: 1447125755940,
      username: "answerhub",
      slug: "answerhub",
      avatar: "https://secure.gravatar.com/avatar/93b9bcd52a21e95be8958cbba2767742?d=identicon&r=PG",
      active: true,
      suspended: false,
      deactivated: false,
      groups: [{
        id: "2",
        creationDate: 1416502952324,
        creationDateFormatted: "11/20/2014 12:02 PM",
        modificationDate: 1416502952530,
        name: "Users"
      }],
      extraData: { }
    }
  end

  let(:multi_response) do
    {
      name: "",
      sort: "active",
      page: 1,
      pageSize: 15,
      pageCount: 1,
      listCount: 1,
      totalCount: 1,
      sorts: ["active", "newest", "hottest"],
      list: [single_response]
    }
  end

  describe '::create' do
    let(:response){ {test:true} }
    let(:url){ Ahub::User.base_url+'.json' }

    it 'calls ::create_resource' do
      expect(Ahub::User).to receive(:create_resource).with(hash_including(:url, :payload, :headers)).and_return(response)
      expect(Ahub::User.create(username: 'u', email:'u@u.com')).to eq(response)
    end

    it 'uses default password if one is not passed in' do
      expect(Ahub::User).to receive(:create_resource).
        with(url:url, payload:{email: 'u@u.com', username: 'u', password: Ahub::DEFAULT_PASSWORD}, headers:Ahub::User.admin_headers)
      Ahub::User.create(username: 'u', email:'u@u.com')
    end

    it 'uses provided password if one is present' do
      expect(Ahub::User).to receive(:create_resource).
        with(url:url, payload:{email: 'u@u.com', username: 'u', password: 'p'}, headers:Ahub::User.admin_headers)
      Ahub::User.create(username: 'u', password:'p', email:'u@u.com')
    end
  end

  describe '::find_by_username' do
    before do
      allow(RestClient).to receive(:get).with(
        "#{Ahub::User.base_url}.json",
        Ahub::User.admin_headers
        ).and_return(server_response.to_json)
    end
  end

  describe '#is_complete?' do
    it 'is tested'
  end

  describe '#answers' do
    it 'is tested'
  end
end
