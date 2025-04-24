redis_url = ENV['REDIS_URL']

puts "REDIS_URL => #{redis_url.inspect}" # TODO Quitar después
if redis_url.blank?
  raise "REDIS_URL is missing in ENV"
end

begin
  uri = URI.parse(redis_url)
rescue URI::InvalidURIError => e
  raise "REDIS_URL is invalid: #{e.message}"
end

JWTSessions.encryption_key = ENV.fetch("JWT_ENCRYPTION_KEY", "milestones-secret-jwt")
JWTSessions.token_store = :redis, {
  redis_host: uri.host,
  redis_port: uri.port,
  redis_db_name: 0,
  token_prefix: "jwt_"
}