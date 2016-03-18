require 'spec_helper'

describe Ahub::Space do
  let(:space){Ahub::Space.new({id: 1000})}

  describe '#initialize' do
    it 'is an Ahub::APIResource' do
      expect(space).to be_a(Ahub::APIResource)
    end

    it 'is an Ahub::Followable' do
      expect(space).to be_a(Ahub::Followable)
    end
  end
end