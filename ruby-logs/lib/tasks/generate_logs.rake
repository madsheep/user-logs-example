require 'ipaddr'
require 'securerandom'
PATHS = %w[
  register login logout profile settings friends friend_requests messages notifications posts photos videos groups events pages games activity search privacy security
  block report feed likes comments followers following message_requests email_notifications push_notifications sms_notifications phone_verification email_verification
  password_reset password_change email_change phone_change username_change deactivate reactivate deactivate_confirmation delete delete_confirmation permissions roles
  sessions devices audit_log billing subscription payment_methods invoices invite reference preferences
]

namespace :logs do
  desc "Puts user session logs in redis stream"
  task :generate do
    $redis = Redis.new(url: ENV["REDIS_URL"])

    users = {}

    1000.times do |n|
      users[[n+1, SecureRandom.hex]] = IPAddr.new(rand(2**32),Socket::AF_INET).to_s
    end

    while true do
      user_id, session_id = users.keys.sample

      if rand(100) == 0
        users[[user_id, session_id]] = IPAddr.new(rand(2**32),Socket::AF_INET).to_s
      end

      payload = {
        user_id: user_id,
        session_id: session_id,
        user_ip: users[[user_id, session_id]],
        timestamp: Time.now.to_s,
        path: "/#{PATHS.sample}"
      }
      $redis.publish("users.logs", JSON.generate(payload))
      sleep(0.2)
    end
  end

end
