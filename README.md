Mortgage Data Extractor
====================

Introduction
---------------------

This program extracts data from mortgage documents, but can be configured to extract data out of any form. Works best with PDF files.

Before You Begin
---------------------
In order to convert images to tex,  you will need a Google Cloud Vision [browser API key](https://cloud.google.com/vision/docs/auth-template/cloud-api-auth?#set_up_an_api_key) in order to read images. 

Create a .env file with the following contents

```
export GCP_API_KEY=YOUR_API_KEY_HERE
```
Install all dependencies with
```
$ bundle install
```

Usage
---
The example implementation can be ran with

```
$ ruby lib/app.rb
```

Docs
---

There are three parts to the program, the [converter](#converter), [extractor](#extractor) and the [post_processor](#postp).

###Converter <a id="converter"></a>
`Converter.call` converts the PDF or Image file into a text string.
```ruby
Converter.call(['path to image1', 'path to image2'])
```
The method can also take alternate image or pdf processors in options. The faults are pdf-reader and Google Cloudvision
```ruby
Converter.call(['path'], {
  :ocr => ImageProcessors::TessractOCR,
  :text_extractors => TextExtractors::PDFReader
})
```
###Extractor <a id="extractor"></a>
The `Extractor` extracts data out of a text string and can be initialized with a key hash.

```ruby
Extractor.new('path to keys')
```

`#train` method accepts a correctly extracted hash and the string in which the data was extracted from and creates a key hash.

```ruby
data = 'Name: John Doe Address: ...'
train_hash = { Name: 'John Doe' }

@extractor.train(data, train_hash)

# key hash
# {
#   name: {
#     before: "Name:",
#     after: "Address:"
#   }
# }
```
The keys generated from the training data can be imported and exported with `#export_keys` and `#import_keys`.
```ruby
@extractor.export_keys('path')
@extractor.import_keys('path')
```
`#extract` will accept a string and attempt to extract data based on the extractor's key hash.
```ruby
data = 'Name: Jane Doe Address: ...'
result = @extractor.extract(data)

# result
# { name: "Jane Doe" }
```

###Post Processor<a id="postp"></a>
The `PostProcessor` does further processing for complex data like liabilities and assets.

`parse_assets` accepts a string of assets and returns an array of asset hashes.

```ruby
assets = 'Asset Stock $ 1.00 Total: $ 1.00'

result = PostProcessor::parse_assets(assets)

# result 
# [
#   { name: "Asset Stock", value: 1.0 },
#   { name: "Total:", value: 1.0 }
# ]
```

`parse_liabs` accepts a string of liabilities and returns an array of liability hashes.
```ruby
liabilities = 'Card $ 1,000.00 $ 200.00 $ 30.00'

result = PostProcessor::parse_liabs(liabilities)

# result 
# [{
#   :name=>"Card",
#   :value=> 1000.0,
#   :balance=> 200.0,
#   :monthly=> 30.0
# }]
```
