require 'pry'
require_relative 'extractor.rb'
require_relative 'converter.rb'
require_relative 'post_processor.rb'

# Initialize extractor and set key hash
extractor = Extractor.new(Dir.pwd + "/lib/extractor_keys/keys.json") 

# convert pdf/image to string
data_string = Converter.call([Dir.pwd + "/images/app.pdf"])
# data_string = Converter.call([Dir.pwd + "/images/app1.jpg", Dir.pwd + "/images/app2.jpg"])


# extract data
extracted_data = extractor.extract(data_string)

# format liabilities and 
PostProcessor::split_assets(extracted_data, :assets)
PostProcessor::split_liabilities(extracted_data, :liabilities)

pp extracted_data
