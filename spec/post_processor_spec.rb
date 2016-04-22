require 'spec_helper'

describe PostProcessor do
  describe '#parse_assets' do
    it 'parses assets key to a hash' do
      data = {
        assets: "Asset1 Stock $ 1.00 Asset2 Car $ 999.00 Total: $ 1,000.00",
        liabs: "liabs"
      }

      result = PostProcessor::parse_assets(data, :assets)
      expect(result).to eq({
        assets: [
          { name: "Asset1 Stock", value: 1.0 },
          { name: "Asset2 Car", value: 999.0 },
          { name: "Total:", value: 1000.0 }
        ],
        liabs: "liabs"
      })
    end
  end

  describe '#parse_liabs' do
    it 'parses liabilities key to a hash' do
      data = {
        assets: "assets",
        liabs: "Card $ 1,000.00 $ 200.00 $ 30.00 Totals $ 1,000.00 $ 200.00 $ 30.00"
      }

      result = PostProcessor::parse_liabs(data, :liabs)
      expect(result).to eq({
        assets: "assets",
        liabs: [
          { :name=>"Card",
            :value=> 1000.0,
            :balance=> 200.0,
            :monthly=> 30.0
          },
          { :name=>"Totals",
            :value=> 1000.0,
            :balance=> 200.0,
            :monthly=> 30.0
          }
        ]
      })
    end
  end
end
