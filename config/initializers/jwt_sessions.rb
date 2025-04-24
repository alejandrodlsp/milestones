redis_url = ENV['REDIS_URL']

puts "REDIS_URL => #{redis_url.inspect}"

JWTSessions.encryption_key = ENV.fetch("JWT_ENCRYPTION_KEY", "milestones-secret-jwt")
JWTSessions.token_store = :redis, {
  redis_url: redis_url,
  token_prefix: "jwt_"
}