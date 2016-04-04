require 'tesseract'
require 'pdf-reader'
require 'pry'

class Extractor
  def initialize
    @key_hash = {}
  end

  attr_accessor :key_hash

  def train(data, hash)
    # Remove duplicate spaces and newlines
    data = data.gsub(/[\n\r]/," ").squeeze(' ')

    hash.each do |key, prop|
      if match = /\s(\S+)\s#{prop}\s(\S+)\s/.match(data)
        before, after = match.captures
        @key_hash[key] = [before, after]
      else
        puts "Error: #{match} was not found in data string."
      end
    end
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
