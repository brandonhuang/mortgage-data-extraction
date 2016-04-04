# Working with Tesseract version 3.02.02_3d
# Export environment variables so compiler can find tessract and leptonica
ENV['CFLAGS'] = '-I/usr/local/Cellar/tesseract/3.02.02_3/include -I/usr/local/Cellar/leptonica/1.72/include'
ENV['LDFLAGS'] = '-L/usr/local/Cellar/tesseract/3.02.02_3/lib -L/usr/local/Cellar/leptonica/1.72/lib'

require 'tesseract'
require 'pdf-reader'
require 'pry'

# OCR test

# e = Tesseract::Engine.new {|e|
#   e.language  = :eng
#   e.blacklist = '|'
# }

# test = e.text_for(Dir.pwd + '/images/app1.jpg')

# PDF reader test

def pdf_to_text(path)
  pdf = PDF::Reader.new(Dir.pwd + path)
  raw_text = ""
  pdf.pages.each do |page|
    raw_text += page.text
  end
  return raw_text
end

def parse_to_map(text)
  hash = Hash.new
  lines = text.gsub(/\:(\s{2,})/, ': ').gsub(/(\s){2,}/, "\n")
  lines.each_line do | line |
    unless /\:/.match(line).nil?
      pair = line.split(':')
      hash[pair[0]] = pair[1].strip
    end
  end
  return hash
end

data = parse_to_map(pdf_to_text('/images/summary.pdf'))

pp data

def extract_data(text)
  match = /(Applicant\(s\)).*/.match(text)
  puts match
end
