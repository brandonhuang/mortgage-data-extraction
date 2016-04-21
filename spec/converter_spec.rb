require 'spec_helper'

module Test
  class OCR
    def initialize(path)
      @path = path
    end
    def run
      "success"
    end
  end
end


describe Converter do
  describe '.call' do
    it 'accepts an array of paths and converts to text' do
      paths = [Dir.pwd + "/spec/test_files/test.png", Dir.pwd + "/spec/test_files/test.pdf"]
      string = Converter.call(paths)

      expect(string).to eq("ABC\n ABC")
    end

    it 'accepts alternate options for text extraction' do
      run = Converter.call([Dir.pwd + "/spec/test_files/test.png"], { ocr: Test::OCR })
      expect(run).to eq("success")
    end
  end

  describe '#new' do 
    it 'returns an instance of converter' do
      @converter = Converter.new(Dir.pwd + "/spec/test_files/test.png")
      expect(@converter).to be_an_instance_of Converter
    end
  end

  describe '#to_s' do
    it 'converts image to text' do
      @converter = Converter.new(Dir.pwd + "/spec/test_files/test.png")
      expect(@converter.to_s.strip).to eq("ABC")
    end

    it 'converts pdf to text' do
      @converter = Converter.new(Dir.pwd + "/spec/test_files/test.pdf")
      expect(@converter.to_s.strip).to eq("ABC")
    end
  end 
end
