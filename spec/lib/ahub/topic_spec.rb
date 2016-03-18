require 'spec_helper'

describe Ahub::Topic do
  let(:topic){Ahub::Topic.new({id: 1000})}

  describe '#initialize' do
    it 'is an Ahub::APIResource' do
      expect(topic).to be_a(Ahub::APIResource)
    end

    it 'is an Ahub::Followable' do
      expect(topic).to be_a(Ahub::Followable)
    end
  end
end