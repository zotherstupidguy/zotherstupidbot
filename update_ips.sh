#!/bin/sh

NICK=itouchthings
SERVER=irc.freenode.net
PORT=6667
CHAN="#ruby"

#PRIVMSG $CHAN :Greetings!
{
  # join channel and say hi
  #JOIN $CHAN
  cat << IRC
NICK $NICK
USER itouchthings 8 x : itouchthings 
WHO $CHAN  %ni
IRC

  # forward messages from STDIN to the chan, indefinitely
#  while read line ; do
#    echo "$line" | sed "s/^/PRIVMSG $CHAN :/"
#  done

  # close connection
  echo QUIT
} | nc $SERVER $PORT | while read -r _ code _ ip _ ; do
case $code in
  354)
    printf '%s\n' "$ip" "$nick"
    ;;
  *)
    ;;
esac
done
