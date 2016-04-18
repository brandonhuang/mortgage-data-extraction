module PostProcessor
  def PostProcessor.parse_assets(hash, assets_key)
    hash[assets_key] = hash[assets_key].scan(/(.*?)(\$\s[\d,]+\.\d{2})/).map do |entry|
      {
        name: entry.first.strip,
        value: entry.last.gsub!(/[^\d\.]/, '').to_f
      }
    end
    return hash
  end

  def PostProcessor.parse_liabs(hash, liabs_key)
    hash[liabs_key] = hash[liabs_key].scan(/(.*?)(\$\s[\d,]+\.\d{2})\s(\$\s[\d,]+\.\d{2})\s(\$\s[\d,]+\.\d{2})/).map do |entry|
      {
        name: entry.first.strip,
        value: entry[1].gsub!(/[^\d\.]/, '').to_f,
        balance: entry[2].gsub!(/[^\d\.]/, '').to_f,
        monthly: entry.last.gsub!(/[^\d\.]/, '').to_f
      }
    end
    return hash
  end
end
