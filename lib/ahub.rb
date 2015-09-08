# require './lib/modules/api_helpers.rb'

class Ahub
  def self.fire
    # p User.find(id: 9) #works
    # p User.create_test_user(prefix: 'rubyuser', index: 99) #works
    # User.create_user_csv(count:100) #works
    # p Answer.create #works
    # (18..20).each{|n| p Answer.create(body: "#{n}: This is my first attempt at answering a question via API")} #works
    p "Done!"
  end
end

require 'ahub/user'
require 'ahub/answer'
