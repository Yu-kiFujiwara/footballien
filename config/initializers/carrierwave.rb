unless Rails.env.development? || Rails.env.test?
    CarrierWave.configure do |config|
      config.fog_credentials = {
        provider: 'AWS',
        aws_access_key_id: 'AKIAWFGZNN6CU2AZ47XD',
        aws_secret_access_key: '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',
        region: 'ap-northeast-1'
      }
  
      config.fog_directory  = 'footballien-photo'
      config.cache_storage = :fog
    end
end