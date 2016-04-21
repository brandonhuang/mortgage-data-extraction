require_relative 'image_processors/google_cloudvision'
require_relative 'text_extractors/pdf_reader'
require 'pry'

class Converter
  def self.call(paths, options = {})
    paths.collect do | path |
      file = new(path, options)
      file.to_s
    end.join(" ")
  end

  def initialize(path, options = {})
    @path       = path
    @options    = options
    @converter  = load_converter(path) 
  end

  def to_s
    @converter.run
  end

  private 
  
  def load_converter(path)
    case File.extname(path)
    when ".pdf"  
      @converter = @options.fetch(:text_extractor) { TextExtractors::PDFReader }
    when ".jpg", ".png" 
      @converter = @options.fetch(:ocr) { ImageProcessors::CloudVision }
    else 
      raise "This file type can't be converted"
    end

    @converter = @converter.new(path)
  end
end
