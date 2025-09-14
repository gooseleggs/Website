---
title: "Getting correct image size from Eagle PCB"
date: 2023-10-06
tags:
  - "electronics"
description: "Printing out a true 1:1 image of the circuit board"
author: "Me"
---

So, having issues getting the correct print size from Eagle PCB on printer.  These steps seem to work for me

- Create the board in Eagle
- Turn off all layers except those wanted, ie Top, Pads, Vias
- File -> Export -> Image
    - Resolution: 600
    - Select Monochrome
    - Give a file name
    - Click OK
- Open file in Gimp
    - Image -> Crop to Content
    - If need to invert image, ie Top mask overlay (Flip Horizontally & Flip vertically), Colors -> Invert
- Save modified image
- Print
    - Page Setup tab
        - Ensure scale is 100%
    - Image Settings tab
        - Draw Crop marks (if needed)
    - Color Tab
        - Monochrome
    - Advanced
        - Print Scaling: None
        - Print Optimization: Graphics
    - Press Print
