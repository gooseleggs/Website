---
title: "Get WkHtmlToPdf to work in CakePHP 2"
date: 2018-11-24
tags: 
  - "cakephp"
description: "Exporting PDF files with CakePhp 2"
author: "Me"
---

Doing a website, and using the code from here: [https://github.com/Milanzor/cakephp-wkhtmltopdf](https://github.com/Milanzor/cakephp-wkhtmltopdf)

Problem was that I was getting blank PDFs back.  Turns out it does not do error handling very well.

After debugging the output command etc, and it bombing out with "host not found" type errors, I copied from the "Tips and URLs" section into AppHelper, and this resolved the issue.

[https://www.dereuromark.de/2014/04/08/generating-pdfs-with-cakephp/](https://www.dereuromark.de/2014/04/08/generating-pdfs-with-cakephp/)

Basically, it just ensures that when printing out to PDF it uses absolute URLs instead of relative (which don't work from a text file)
