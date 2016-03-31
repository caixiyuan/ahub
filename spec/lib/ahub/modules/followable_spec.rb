require 'spec_helper'

describe Ahub::Followable do
  let(:api_response) { {"name"=>"", "sort"=>"", "page"=>0, "pageSize"=>1, "pageCount"=>538, "listCount"=>1, "totalCount"=>538, "list"=>[{"id"=>124338, "type"=>"user", "creationDate"=>1454199009000, "creationDateFormatted"=>"01/31/2016 12:10 AM", "modificationDate"=>1458070203000, "username"=>"KikiFernandes", "slug"=>"kikifernandes", "gold"=>2, "silver"=>3, "bronze"=>9, "reputation"=>406, "moderator"=>false, "superuser"=>false, "emailHash"=>"f3715ffa6ddda747ea9fcdd7139a286aa7ec249dd75df2b15ecb92f5687d52ec", "avatar"=>"http://www.thebump.com/real-answers/users/124338/photo/view", "postCount"=>9, "followerCount"=>3, "followCount"=>0, "userFollowCount"=>0, "active"=>true, "suspended"=>false, "deactivated"=>false, "groups"=>[{"id"=>"3", "creationDate"=>1425419929000, "creationDateFormatted"=>"03/03/2015 09:58 PM", "modificationDate"=>1450716555000, "name"=>"Users"}]}]} }
  let(:faked_followers) { api_response["list"].map { |item| Ahub::User.new(item) } }
  
  describe '#followers' do
    it 'returns exmpty array when node_id is not specified' do
      tester = Ahub::Question.new({id: nil})
      expect(tester.followers).to eq([])
    end

    it 'returns correct followers' do
      tester = Ahub::Question.new({id: 15500})
      allow(Ahub::Question).to receive(:get_resources).with(
        url: "#{Ahub::DOMAIN}/services/v2/node/#{tester.id}/followers.json?page=0&pageSize=20",
        headers: Ahub::Question.admin_headers,
        klass: Ahub::User
      ).and_return(faked_followers)
      expect(tester.followers).to eq(faked_followers)
    end
  end
end