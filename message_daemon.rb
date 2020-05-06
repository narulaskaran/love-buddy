#typed: ignore

require 'daemons'

Daemons.run(__dir__ + '/main.rb')
