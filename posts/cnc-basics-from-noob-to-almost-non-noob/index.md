---
title: "CNC Basics (from Noob to almost non-Noob)"
date: 2018-01-28
tags: 
  - "cnc"
description: "Basic usage of a CNC machine - basically to help me remember"
author: "Me"
---

Purchased a 2417 CNC machine to have a play around.  Seems OK, though quite a big learning curve.

This is to list things that I work out and start to document.

The machine has a lazeraxe control module on it.  It came with GRBL 0.8 which is quite behind (currently 1.1 as of this writing).  However, I flashed it with the latest version, and then lost control of the axis!  A quick frantic google later and I found the .hex code for the old 0.8 version - put it back and phew - it was back alive.   I used Eagle to create my first CNC circuit, started to print it, and broke the bit about 1 minute into etching the board.  I let it continue, but not the best.  I then went googling, and read about autolevelling software.  To use this, it looks like you need 0.9g or later of the firmware.  Also, in my googling, I found a Github site (https://github.com/1wise) where Henri had create a newer version of the firmware for the board).  Compiled this and away we go (so it would appear).

To get the probe function, I will be using PIN 5 of the Nano and ground and do some testing.

As for the G-code sending application - I started off with GRBL Controller, then moved to Candle.  I am now looking at bCNC as this has auto-levelling software in it.  I might also look at Candle as there is a newer version for >1 GRBL firmware.

Commands that I have worked out

`G0` - Fast moving commands 
`G1` - Slow moving commands

To set the spindle speed: `Sx` where *x* is a speed, ie `S10000`

To set the feed rate, add a F parameter after the G0 or G1 command, ie "G01 F500".  I sometimes needed to set the feedrate if the controller reset and I couldn't use the jog controls any longer.

After you set the 0 points, to return to this location, use the commands

`G0 Z0` 
`G0 X0 Y0`

This raises/lowers the Z axis to the 0 position, then moves the head back to 0,0
