unless Rails.env.development? || Rails.env.test?
    CarrierWave.configure do |config|
      config.fog_credentials = {
        provider: 'AWS',
        aws_access_key_id: 'AKIAJMOPEQF3VXSKWXOQ',
        aws_secret_access_key: '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',
        region: 'ap-northeast-1'
      }
  
      config.fog_directory  = 'rails-photo-123'
      config.cache_storage = :fog
    end
end