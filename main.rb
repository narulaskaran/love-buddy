#typed: true

require 'sorbet-runtime'
require(T.must(__dir__) + '/buddy')

# Initialize Buddy in relation to config directory
boo = Buddy.new(T.must(__dir__) + "/config")

# Create log file
logPath = T.must(__dir__) + "/config/buddy.log"
if !File.exists?(logPath)
  log = File.new(logPath, "w")
  log.write("Initialize log file\n")
  log.close()
end


loop do
  log = File.open(logPath, "a")

  sent = boo.sendText
  if sent
    log.write("#{Time.now} ---- Successfully sent message")
  else
    log.write("#{Time.now} ---- Message was not sent")
  end

  log.write("\n")
  log.close()
  sleep(60 * 60 * 6)  # Sleep for 6 hours and check status again
end