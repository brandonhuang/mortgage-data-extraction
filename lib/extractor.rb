require 'pry'
require 'json'

class Extractor
  def initialize(path = nil)
    path.nil? ? @key_hash = {} : @key_hash = load_keys(path)
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
        raise "Error: #{key} was not found in data string."
      end
    end
  end

  def export_keys(path = Dir.pwd + '/lib/extractor_keys/keys.json')
    File.open(path, "w") { |f| f << JSON.pretty_generate(@key_hash) }
  end

  def load_keys(path)
    @key_hash = JSON.parse(IO.read(path), symbolize_names: true)
  end

  def extract(data, methods = {})
    data = data.gsub(/[\n\r]/," ").squeeze(' ')

    @key_hash.each do |key, prop|
      if prop[:before].nil? && match = /(.*?)\s#{prop[:after]}\s/.match(data)
        @return_hash[key] = match.captures.first
      elsif prop[:after].nil? && match = /\s#{prop[:before]}\s(.*?)/.match(data)
        @return_hash[key] = match.captures.first
      elsif match = /\s#{prop[:before]}\s((?:(?!#{prop[:before]}).)*?)\s#{prop[:after]}\s/.match(data)
        @return_hash[key] = match.captures.first
      else
        puts "#{key} data was not found in document."
      end
    end
    
    raise "No data was found" if @return_hash.empty? 

    # Run post processing of data if specified
    methods.each do |method, key|
      if self.methods.include? method
        method(method).call(key)
      else
        raise "#{method} is not an extractor method"
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
