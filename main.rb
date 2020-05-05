#typed: true

require 'sorbet-runtime'
require(__dir__ + '/buddy')

# Initialize Buddy in relation to config directory
boo = Buddy.new(__dir__ + "/config")

loop do
  sent = boo.sendText
  if sent
    puts "Successfully sent message"
  else
    puts "Message was not sent"
  end
  sleep(60 * 60 * 6)  # Sleep for 6 hours and check status again
end