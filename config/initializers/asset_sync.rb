if defined?(AssetSync)
  AssetSync.configure do |config|
    config.fog_provider = "AWS"
    config.aws_access_key_id = ENV["AWS_ACCESS_KEY_ID"]
    config.aws_secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
    config.fog_directory = "campfire-storage-bucket"
    config.fog_region = "us-east-2"
    config.existing_remote_files = "delete" # or 'keep'
    config.gzip_compression = true
  end
end
