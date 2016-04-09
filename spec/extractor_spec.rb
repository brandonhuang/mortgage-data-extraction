require 'spec_helper'

describe Extractor do
  before :each do
    @extractor = Extractor.new
  end

  describe "#new" do
    it "returns an Extractor object" do
        @extractor = Extractor.new
        expect(@extractor).to be_an_instance_of Extractor
    end
  end
end
