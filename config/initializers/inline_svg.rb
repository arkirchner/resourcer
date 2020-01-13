InlineSvg.configure do |config|
  config.raise_on_file_not_found = true

  config.asset_file = InlineSvg::CachedAssetFile.new(
    paths: [
      "#{Rails.root}/app/assets/images",
      "#{Rails.root}/node_modules/@fortawesome/fontawesome-free/svgs",
    ],
    filters: /\.svg/,
  )
end
