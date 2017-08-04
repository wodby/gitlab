production:
  # Redis (single instance)
  url: redis://redis:6379
  ##
  # Redis + Sentinel (for HA)
  #
  # Please read instructions carefully before using it as you may lose data:
  # http://redis.io/topics/sentinel
  #
  # You must specify a list of a few sentinels that will handle client connection
  # please read here for more information: https://docs.gitlab.com/ce/administration/high_availability/redis.html
  ##
  # url: redis://master:6379
  # sentinels:
  #   -
  #     host: slave1
  #     port: 26379 # point to sentinel, not to redis port
  #   -
  #     host: slave2
  #     port: 26379 # point to sentinel, not to redis port