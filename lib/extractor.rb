require 'tesseract'
require 'pdf-reader'
require 'pry'

class Extractor
  def initialize
    @key_hash = {}
  end

  attr_accessor :key_hash

  # train data is an array containing hashes with the corresponding document and successfully extracted hash
  def train(train_data)
    result = []

    train_data.each do | train_set |
      # Remove duplicate spaces and newlines
      doc = train_set[:doc].gsub(/[\n\r]/," ").squeeze(' ')

      match_keys = {}

      train_set[:to_extract].each do |key, prop|
        if matches = doc.scan(/\s(\S+)\s#{prop}\s(\S+)\s/)
          match_keys[key] = matches
          puts "Success, #{prop} was matched #{matches.count} time(s)"
        else
          puts "Error: #{match} was not found in data string."
        end
      end

      result.push match_keys
    end
    i = 0
    pp result[i][:name]
    pp result[i+1][:name]
    # pp result[i][:name] & result[i+1][:name]
  end

  def extract(data)
    data = data.gsub(/[\n\r]/," ").squeeze(' ')
    return_hash = {}

    @key_hash.each do |key, prop|
      if match = /\s#{prop.first}\s(.*?)\s#{prop.last}\s/.match(data)
        return_hash[key] = match.captures.first
      else
        puts "Error: Data between #{prop.first} and #{prop.last} could not be found."
      end
    end

    return return_hash
  end
end
