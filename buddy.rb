#typed: true

require 'sorbet-runtime'
require 'json'

class Buddy
  extend T::Sig

  # Accepts a path to the config directory
  sig {params(path: String).void}
  def initialize(path)
    @configDirectory = path

    config = parseJSON(@configDirectory + "/app_settings.json")
    @lastFired = File.read(@configDirectory + "/last_fired")

    @him = config['my-name']
    @her = config['her-name']
    @num = config['her-number']
    @messages = config['messages']
  end

  # Opens JSON file and parses content
  sig {params(path: String).returns(T::Hash[String, T.any(String, T::Array[String])])}
  def parseJSON(path)
    file = File.read(path)
    json = JSON.parse(file)

    return json
  end

  # Chooses a random message from the loaded samples
  sig {returns(String)}
  def chooseMessage
    @messages.sample
  end

  # Checks when the last message was sent.
  # Returns true and updates time log if we're a go for sending a new one.
  # Otherwise returns false and sets a target time to send.
  sig {returns(T::Boolean)}
  def checkTiming
    # Read in when the most recent message was sent

    # If it was less than 48 hours ago, return false

    # If the current time is not between 11AM and 6pm, return false
    # I call this the 'latent window'
    #   -- the time period between "good morning" texts and "how was your day" texts

    # If either of the checks were false, we want to check back again in 6 hours

    # If we passed the above conditions, let's send it off
    true
  end

  # Sends a message to the saved number.
  # If process succeeds, returns true.e
  # Otherwise returns false.
  sig {params(text: String).returns(T::Boolean)}
  def sendText(text)
    # Choose a message different from the most recent one
    loop do
      message = chooseMessage
      break if message == @lastFired
    end

    # Use some API to send the message

    # On success, update @lastFired to be the just-sent message

    # Log the timestamp so we can keep track of when the most recent message was fired

    # Return false if there was an error

    true
  end

end