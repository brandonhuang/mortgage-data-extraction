require 'pdf-reader'
module TextExtractors
  class PDFReader
    attr_reader :path
    def initialize(path)
      @path = path
    end

    def run
      pdf.pages.map do |page|
        page.text
      end.join
    end

    private

    def pdf
      @pdf ||= PDF::Reader.new(path)
    end
  end
end
