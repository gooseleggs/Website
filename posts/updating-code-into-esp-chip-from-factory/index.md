---
title: "Updating code into ESP chip from factory"
date: 2023-08-05
tags:
 - "electronics"
description: "Notes about writing to flash from the command line"
author: "Me"
---

When getting a new module/board, you need to load code into it.  After the code is created in ESPHome, download it for manual install, then use the following command to load it into the chip

```
esptool.py --chip auto -p /dev/ttyUSB0 write_flash 0x0 ~/snap/chromium/current/Downloads/file.bin
```
