#typed: true

require 'sorbet-runtime'
require './buddy'

if __FILE__ == $0
  buddy = Buddy.new("./config")
  puts buddy.chooseMessage
end