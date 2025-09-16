Aws.config.update({
  region: "us-east-2",
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY'], ENV['AWS_ACCESS_SECRET'])
})