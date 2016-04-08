# Working with Tesseract version 3.02.02_3d
# Export environment variables so compiler can find tessract and leptonica
ENV['CFLAGS'] = '-I/usr/local/Cellar/tesseract/3.02.02_3/include -I/usr/local/Cellar/leptonica/1.72/include'
ENV['LDFLAGS'] = '-L/usr/local/Cellar/tesseract/3.02.02_3/lib -L/usr/local/Cellar/leptonica/1.72/lib'

require 'tesseract'
module ImageProcessors
  class Tesseract
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def run
      engine.text_for(@path)
    end

    private

    def engine
      @engine = Tesseract::Engine.new { |e|
        e.language  = :eng
        e.blacklist = '|'
      }
    end
  end
end