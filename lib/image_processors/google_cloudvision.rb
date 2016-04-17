require 'rest-client'
require 'dotenv'
require 'base64'
require 'json'
require 'uri'

module ImageProcessors
  class CloudVision
    def initialize(path)
      @path = path
    end

    def run
      image = open_or_download @path
      base64_image = base64_encode image
      request_body = create_request_body base64_image
      response = RestClient.post(api_url, request_body, 'Content-Type' => 'application/json')
      return JSON.parse(response.to_str)["responses"][0]["textAnnotations"][0]["description"]
    end

    private

    def create_request_body(base64_image)
      {
        requests: [{
          image: {
            content: base64_image
          },
          features: [
            {
              type: 'TEXT_DETECTION',
              maxResults: 10
            }
          ]
        }]
      }.to_json
    end

    def base64_encode(image)
      Base64.strict_encode64(image)
    end

    def open_or_download(image_file)
      if URI.extract(image_file).first.nil? then
        File.new(image_file, 'rb').read
      else
        RestClient.get(image_file)
      end
    end

    def api_url
      Dotenv.load
      "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GCP_API_KEY']}"
    end
  end
end

# ImageProcessors::CloudVision.new.request('TEXT_DETECTION', 'https://storage.googleapis.com/buckot/app2.jpg')
