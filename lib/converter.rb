require 'pry'
require 'pdf-reader'
require 'tesseract'

class Converter
  def initialize
  end

  def self.to_s(path)
    ext = File.extname path

    if ext == ".pdf"
      pdf_to_s path
    elsif ext == ".jpg"
      img_to_s path
    end
  end

  def self.img_to_s(path)
    e = Tesseract::Engine.new { |e|
      e.language  = :eng
      e.blacklist = '|'
    }

    e.text_for(path)
  end

  def self.pdf_to_s(path)
    pdf = PDF::Reader.new(path)
    raw_text = ""
    pdf.pages.each do |page|
      raw_text += page.text
    end
    return raw_text
  end
end
