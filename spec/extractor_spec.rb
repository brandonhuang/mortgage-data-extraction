require 'spec_helper'

describe Extractor do
  describe '#new' do
    it 'returns an untrained extractor when no path is provided' do
      @extractor = Extractor.new
      expect(@extractor).to be_an_instance_of Extractor
    end

    it 'returns a trained extractor object when a path is provided' do
      @extractor = Extractor.new(Dir.pwd + '/spec/test_files/keys.json')
      expect(@extractor.key_hash).to eq({
        :test => {
          :before => "before",
          :after => "after"
        }
      })
    end

    it 'throws an error when incorrect path is provided' do
      expect { @extractor = Extractor.new("test") }.to raise_error(/No such file or directory/)
    end
  end

  describe '#import_keys' do
    it 'imports a key hash from path' do
       @extractor = Extractor.new
      @extractor.import_keys(Dir.pwd + '/spec/test_files/keys.json')
      expect(@extractor.key_hash).to eq({
        :test => {
          :before => "before",
          :after => "after"
        }
      })
    end
  end

  describe '#train' do 
    before(:each) do
      @extractor = Extractor.new
    end

    it 'sets the correct key_hash given a training set' do
      data = '1 Name: Aaron Passions: Anime'
      train_hash = {
        id: "1",
        name: "Aaron",
        passions: "Anime"
      }

      @extractor.train(data, train_hash)
      expect(@extractor.key_hash).to eq({
        :id => {
          :after => "Name:"
        },
        :name => {
          :before => "Name:",
          :after => "Passions:"
        },
        :passions => {
          :before => "Passions:"
        }
      })
    end

    it 'raises an error when training data is incorrect' do
      data = 'Name: John'
      train_hash = {
        name: "Aaron"
      }

      expect {@extractor.train(data, train_hash)}.to raise_error('Error: name was not found in data string.')
    end
  end

  describe '#extract' do
    before(:all) do
      @extractor = Extractor.new
      @extractor.key_hash = {
        :id => {
          :after => "Name:"
        },
        :name => {
          :before => "Name:",
          :after => "Passions:"
        },
        :passions => {
          :before => "Passions:"
        }
      }
    end

    it 'extracts data based on key_hash' do
      data = '123 Name: John Doe Passions: Running'
      expect(@extractor.extract(data)).to eq({
        :id => '123',
        :name => "John Doe",
        :passions => "Running"
      })
    end

    it 'is case insensitive' do
      data = '123 name: John Doe passions: Running'
      expect(@extractor.extract(data)).to eq({
        :id => '123',
        :name => "John Doe",
        :passions => "Running"
      })        
    end

    it 'unmatched keys are nil' do
      data = 'Name: John Doe Passions:'
      expect(@extractor.extract(data)).to eq({
        :id => nil,
        :name => "John Doe",
        :passions => nil
      })
    end

    it 'raises an error when training there are no matches' do
      data = ''
      expect {@extractor.extract(data)}.to raise_error('Error: No data was matched')
    end
  end

  describe '#clean' do
    before(:all) { @extractor = Extractor.new }

    it 'removes excess whitespace' do
      string = '    test:     string    '

      expect(@extractor.clean(string)).to eq("test: string")
    end

    it 'removes carraige returns and newlines' do
      string = "test: \n\r string"

      expect(@extractor.clean(string)).to eq("test: string")
    end
  end
end
