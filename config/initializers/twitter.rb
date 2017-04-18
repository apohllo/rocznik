#!/usr/bin/ruby

require 'twitter'

USERNAME = 'dzikichomikor'
CONSUMER_KEY = 'paUTI2G88ytTU5ZaP8vUcpTZG'
CONSUMER_SECRET = 'jNGjMZ11ZaIHNXEi1w9AlOwqMdmT77DjLAtSAf37oSR0bnGFex'
OAUTH_TOKEN = '705255726915133440-qMqe7B4fDYHony4t2t5NON6P3lXru41'
OAUTH_TOKEN_SECRET = 'iluNMwCuFOjBC7fo8cgM0Azb3IAiZoNRT6PFf0S90b6Ri'

twitter = Twitter::Twitter.new(
  :consumer_key => CONSUMER_KEY,
  :consumer_secret => CONSUMER_SECRET,
  :oauth_token => OAUTH_TOKEN,
  :oauth_token_secret => OAUTH_TOKEN_SECRET
)

follower_ids = []
twitter.follower_ids(USERNAME).each do |id|
  follower_ids.push(id)
end

friend_ids = []
twitter.friend_ids(USERNAME).each do |id|
  friend_ids.push(id)
end

twitter.follow(follower_ids - friend_ids)