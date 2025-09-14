---
title: "What the FLIRC"
date: 2020-07-13
author: "Me"
description: "Replacing a remote control on LIRC with a USB dongle"
tags:
 - "mythtv"
---

So, purchased a FLIRC to replace an older MCE USB IR receiver.  Wanted to do this, as I am going to upgrade OS, and didn't want to muck around with LIRC settings.  Having something that just is a keyboard is a great concept.  Unfortunately, it took longer to get going than what I expected.

I use a Harmony 650 remote, and while an OK remote, does not seem to place nicely with FLIRC.  OK - let me say this, I have it trained to the old Microsoft remote that I had, and it is giving me 0.5 second delays between keypresses, not matter what inter delay setting I choose.  That is for another post.

The issues I had with FLIRC (and possibly related to the Microsoft MCE), is that when I was pressing the button, I was getting two distinct codes.  Turns out, with the remote, is that it is basically alternating what it sending.  So, to fix this, either use a different profile, or do what I did - record the button twice.  This also means that if you want to remove the button, you need to erase it two in the FLIRC GUI as well.  This took way longer to Google than I would wanted.  Anyway - a successful conclusion.

Next was to to the hardest bit.  Replace the _restart myth frontend_ capability.  In LIRC, I used configured in the config file the file to run when a button on the remote is pressed.  You cannot do that with FLIRC, as it mimics a keyboard.  Best option is to get something to listen to a keyboard shortcut.  So, since running XFCE desktop, I used the _Keyboard_ settings panel to associate the CTRL-~ key to run a command: /home/myth/restartFrontend.sh.  Turns out to work like a charm!
