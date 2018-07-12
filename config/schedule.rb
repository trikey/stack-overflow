every 1.days do
  runner 'DailyDigestJob.perform_now'
end

every 60.minutes do
  rake 'ts:index'
end