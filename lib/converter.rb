require_relative 'image_processors/tesseract_ocr'
require_relative 'text_extractors/pdf_reader'
require_relative 'image_processors/google_cloudvision.rb'
require 'pry'
require 'pdf-reader'
require 'tesseract'

class Converter
  def self.call(paths)
    paths.collect do | path |
      file = new(path)
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
      @converter = @options.fetch(:text_extractor) { TextExtractors::PDFReader.new(path) }
    when ".jpg" 
      @converter = @options.fetch(:ocr) { ImageProcessors::TesseractOCR.new(path) }
    else 
      raise "This file type can't be converted"
    end
  end
end
