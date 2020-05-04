#typed: true

require 'sorbet-runtime'
require './buddy'

if __FILE__ == $0
  # Initialize Buddy in relation to config directory
  boo = Buddy.new("./config")
  sent = boo.sendText

  if sent
    puts "Successfully sent message"
  else
    puts "Message was not sent"
  end

end