require 'pry'

class Extractor
  def initialize
    @key_hash = {}
    @return_hash = {}
  end

  attr_accessor :key_hash

  def train(data, hash)
    # Remove duplicate spaces and newlines
    data = data.gsub(/[\n\r]/," ").squeeze(' ')

    hash.each do |key, prop|
      if match = Regexp.new('\s(\S+)\s' + Regexp.quote(prop) + '\s(\S+)\s').match(data)
        before, after = match.captures
        @key_hash[key] = {before: before, after: after}
      elsif match = Regexp.new('\s(\S+)\s' + Regexp.quote(prop)).match(data)
        before = match.captures.first
        @key_hash[key] = {before: before}
      elsif match = Regexp.new(Regexp.quote(prop) + '\s(\S+)\s').match(data)
        after = match.captures.first
        @key_hash[key] = {after: after}
      else
        puts "Error: #{key} was not found in data string."
      end
    end
  end

  def extract(data, methods = {})
    data = data.gsub(/[\n\r]/," ").squeeze(' ')

    @key_hash.each do |key, prop|
      if prop[:before].nil? && match = /(.*?)\s#{prop[:after]}\s/.match(data)
        @return_hash[key] = match.captures.first
      elsif prop[:after].nil? && match = /\s#{prop[:before]}\s(.*?)/.match(data)
        @return_hash[key] = match.captures.first
      elsif match = /\s#{prop[:before]}\s(.*?)\s#{prop[:after]}\s/.match(data)
        @return_hash[key] = match.captures.first
      else
        puts "Error: #{key} data was not found in document."
      end
    end

    methods.each do |method, key|
      if self.methods.include? method
        method(method).call(key)
      else
        puts "Error: #{method} is not a method"
      end
    end

    return @return_hash
  end

  def split_assets(assets)
    @return_hash[assets] = @return_hash[assets].scan(/(.*?)(\$\s[\d,]+\.\d{2})/).map do |entry|
        {
          name: entry.first.strip,
          amount: entry.last.gsub!(/[^\d\.]/, '').to_f
        }
    end
  end

  def split_liabilities(liabilities)
    @return_hash[liabilities] = @return_hash[liabilities].scan(/(.*?)(\$\s[\d,]+\.\d{2})\s(\$\s[\d,]+\.\d{2})\s(\$\s[\d,]+\.\d{2})/).map do |entry|
      {
        name: entry.first.strip,
        value: entry[1].gsub!(/[^\d\.]/, '').to_f,
        balance: entry[2].gsub!(/[^\d\.]/, '').to_f,
        monthly: entry.last.gsub!(/[^\d\.]/, '').to_f
      }
    end
  end
end
