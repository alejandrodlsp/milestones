redis_url = ENV['REDIS_URL']
uri = URI.parse(redis_url)

JWTSessions.encryption_key = ENV.fetch("JWT_ENCRYPTION_KEY", "milestones-secret-jwt")
JWTSessions.token_store = :redis, {
  redis_host: uri.host,
  redis_port: uri.port,
  redis_db_name: 0,
  token_prefix: "jwt_"
}