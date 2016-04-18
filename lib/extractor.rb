require 'pry'
require 'json'

class Extractor
  attr_accessor :key_hash

  def initialize(path = nil)
    path.nil? ? @key_hash = {} : @key_hash = import_keys(path)
    @return_hash = {}
  end

  def import_keys(path)
    @key_hash = JSON.parse(IO.read(path), symbolize_names: true)
  end

  def export_keys(path = Dir.pwd + '/lib/extractor_keys/keys.json')
    File.open(path, "w") { |f| f << JSON.pretty_generate(@key_hash) }
  end

  def train(data, hash)
    data = clean(data)

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

  def extract(data)
    data = clean(data)
    @return_hash = {}

    @key_hash.each do |key, prop|
      if prop[:before].nil? && match = /(.*)\s#{prop[:after]}\s/i.match(data)
        match = match.captures.first
      elsif prop[:after].nil? && match = /\s#{prop[:before]}\s(.*)/i.match(data)
        match = match.captures.first
      elsif match = /(?:^|\s)#{prop[:before]}\s(.*?)\s#{prop[:after]}(?:\s|$)/i.match(data)
        match = match.captures.first
      else
        warn "#{key} data was not found in document"
        match = nil
      end

      @return_hash[key] = match
    end

    raise "Error: No data was matched" if @return_hash.all? { |key, val| val.nil? }

    return @return_hash
  end

  def clean(data)
    data = data.gsub(/[\n\r]/," ").squeeze(' ').strip
  end
end
