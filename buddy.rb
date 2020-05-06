#typed: true

require 'sorbet-runtime'
require 'json'
require 'imessage'

class Buddy
  extend T::Sig

  @@RANDOM_FILLER = "AUTOMATICALLY GENERATED"

  # Accepts a path to the config directory
  sig {params(path: String).void}
  def initialize(path)
    @configDirectory = path
    configJSON = @configDirectory + "/app_settings.json"
    @configLastMessage = @configDirectory + "/last_fired"

    # Read in JSON config
    config = parseJSON(configJSON)

    # Read in last message
    exists?(@configLastMessage)
    @lastFired = File.read(@configLastMessage)

    @her = config['name']
    @num = config['number']
    @messages = config['messages']
  end

  # Checks if a file exists
  # If not, makes a new one
  # Returns contents of that file
  sig {params(filePath: String).returns(String)}
  def exists?(filePath)
    content = ""
    if !File.exists?(filePath)
      file = File.new(filePath, "w")
      file.write(@@RANDOM_FILLER)
      file.close()
      content = @@RANDOM_FILLER
    else
      content = File.read(filePath)
    end

    return content
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
    validWindow = T.let(true, T::Boolean)
    now = Time.now

    # Read in when the most recent message was sent
    lastSend = File.mtime(@configLastMessage)

    # If it was less than 48 hours ago, return false
    hoursAgo = (now - lastSend) / 3600
    if hoursAgo < 48 and @lastFired != @@RANDOM_FILLER
      validWindow = false
      puts "Last message was sent too recently"
    end

    # If the current time is not between 11AM and 6pm, return false
    # I call this the 'latent window'
    #   -- the time period between "good morning" texts and "how was your day" texts
    if now.hour < 11 or now.hour > 18
      puts "Outside the latent window"
      validWindow = false
    end

    validWindow
  end

  # Sends a message to the saved number.
  # If process succeeds, returns true.e
  # Otherwise returns false.
  sig {returns(T::Boolean)}
  def sendText
    # Check if we're within the latent window
    return false if !checkTiming

    # Choose a message different from the most recent one
    message = ""
    loop do
      message = chooseMessage
      break if message != @lastFired
    end

    # Use the iMessage gem to end via the command line
    message_command = "imessage --text '#{message}' --contacts #{@num}"
    exec(message_command) if fork.nil?

    # Update @lastFired to be the just-sent message -- retrying up to 5 times
    messageLogged = T.let(false, T::Boolean)
    for i in (1..5)
      begin
        puts "Trying to update log file"
        messageLogged = updateLastFiredMessage(message)
        break if messageLogged
        puts "Couldn't update everything..."
      rescue => exception
        puts "There was an IOError while writing to disk"
      end
    end

    # Return whether the message was successfully sent and logged
    messageLogged
  end

  # Takes the most recently sent message
  # Overwrites the last_fired log file to save the newly sent message
  # Returns true if the write was succesful
  # Throws IOError if there was a problem
  sig {params(newMessage: String).returns(T::Boolean)}
  def updateLastFiredMessage(newMessage)
    @lastFired = newMessage

    begin
      lenWritten = File.write(@configLastMessage, @lastFired)
      return false if lenWritten != newMessage.length
    rescue => exception
      raise
    end

    true
  end

end