# Love Buddy

## What...?
Helping men everywhere keep their girlfriends happy. Inspired by my favorite lady.
People have different love languages and different ways of showing they care.
Love Buddy can help bridge the gap between them. Basically an automated iMessage script. Chooses a different cute message every 2-3 days and sends it out to a recipient of your choice.

There's currently a very small list of messages to choose from (see `config/app_settings.json`), so suggestions welcome.

## How to use
Go into `config/app_settings.json` and type in your recipient's name and phone number. In lieu of a phone number you can probably use their Apple ID but I haven't tested this yet.

Open a terminal in the main repo directory and type `bundle` to download all necessary gems.

Run `ruby message_daemon.rb start` in the main project directory. This will run the `main.rb` script as a background process. If you reboot your machine you'll have to come back here and start the process again manually.

Run `ruby message_daemon.rb stop` from the main project directory to end the process.

## Next steps
I wanted to refresh my Ruby skills a little bit and this was a good exercise to do that. I also want to practice some web development so I might go for a web app/controller for this next.

## Known Issue
There's some issue with a long-running daemon not being able to invoke system calls after the computer wakes up from hibernation. If this occurs, you'll have to manually restart the process. Haven't had time to look into a workaround with university coursework.

## Wow, I think I love you now
Thanks, I love you too. [Hit me up.](https://narula.xyz/)
