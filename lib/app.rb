require 'pry'
require_relative 'extractor.rb'
require_relative 'converter.rb'
require_relative 'post_processor.rb'
require_relative 'image_processors/google_cloudvision.rb'
require_relative 'text_extractors/pdf_reader.rb'

# Initialize extractor and set key hash
extractor = Extractor.new(Dir.pwd + "/lib/extractor_keys/keys.json") 

# convert pdf/image to string
data_string = Converter.call([Dir.pwd + "/images/app1.jpg"], {
  :ocr => ImageProcessors::CloudVision,
  :text_extractor => TextExtractors::PDFReader
})

# extract data
extracted_data = extractor.extract(data_string)

# format liabilities and 
PostProcessor::parse_assets(extracted_data, :assets)
PostProcessor::parse_liabs(extracted_data, :liabilities)

pp extracted_data
