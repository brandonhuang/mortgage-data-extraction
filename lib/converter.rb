require 'pry'
require 'pdf-reader'
require 'tesseract'

class Converter
 
  def self.call(path)
    file = new(path)
    file.to_s
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

  
  def load_converter
    case File.extname(@path)
    when ".pdf"  
      @converter = @options.fetch(:ocr) { ImageProcessors::Tesseract.new(path) }
    when ".jpg" 
      @converter = @options.fetch(:text_extractor) { TextExtractors::PDFReader.new(path) }
    else 
      raise "This file type can't be converted"
    end
  end
end
