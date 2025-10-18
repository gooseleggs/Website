---
title: Bye Bye WordPress...Nice knowing you
date: 2025-09-14
tags:
  - general
description: Why the change from WordPress, and the impressive gains
author: Me
---
# Overview
WordPress was not my first blog site.  Previous to this I had used sPHPBlog and also Dokuwiki.  sPHPBlog I liked, but it was rigid in its theme.  I was also experimenting with wikis as well, hence Dokuwiki.  I am not sure of the reasons I went with WordPress - probably popularity, ease of use, and the amount of plugins.

This worked well for a number of years, but then I changed....

- I was getting annoyed at the number of low life people out there were trying to break into WordPress.
- I was getting annoyed at the number of vulnerabilities posted for WordPress plugins there were - none of the ones luckily I was using - but it was only time.
- It was getting large for the amount of blogs contained on it.
- While I had auto-updates on, it still needed tending too every so often.
- I was using Markdown now, and while WordPress can accept markdown, refer to above issues.

So, I started a search for something different, and then came across Eleventy.  This is what now powers this site.

## WordPress
Here are the details of the running WordPress *before* I moved away from it.  None of it was optimized.  

| Image / Component                      | Size  |
| -------------------------------------- | ----- |
| WordPress 5.8-php8.1-apache  container | 624MB |
| MySQL database container               | 450MB |
| HTML volume                            | 450MB |
| SQL Data                               | 304MB |
| Backups                                | 4.3GB |

NOTE: Backups is there for historical state.  These don't really make up the overall size, but still consume space for the solution.

Anyway, lets say, **~1.8GB** for the website, for 39 blog entries.

This yielded the following Lighthouse scores for mobile, and then desktop:

![](Pasted%20image%2020250914132529.png)

![](Pasted%20image%2020250914132544.png)
## Static WordPress Site
So, the next iteration, was to turn WordPress into a static site.  That will get rid of people able to hack the admin password as the backend does not exist.  So, using the Static Website plugin for WordPress, I got it to create an export for me.  First of course, I disabled comments and search.

This yielded me a **90MB** static website for **39 blog entries**.

This yielded a lightning page speed of the following (desktop, and then mobile renderings):

![](Pasted%20image%2020250914131420.png)

![](Pasted%20image%2020250914131352.png)
Only a slight increase in speed which was surprising, considering there was no language to interpret (PHP).  This would speak to the output not being optimized.
## Eleventy
While the comparison is not going to be 100%, due to removing some old blogs, these are the stats for the demo site.  There are now 19 blog entries excluding this one.

Size of site: **2.3MB**, or (754MB (HTML+SQL data) / 2.3MB) = **0.3% of the WordPress site.** 

Backups are done in Git, which means, I can get version control of it as well.

Not yet utilizing, but will look at some point:
- Different image sizes for different display size.
- Git pipelines to check-in, and then deploy.

Out of the box, I obtained the following (mobile, then desktop):

![](Pasted%20image%2020250914141042.png)

![](Pasted%20image%2020250914141100.png)

**Update 21 Sept 2025**
I have now updated the Eleventy website with a few additional features:
- Automatic selection of images based on the size of the device.
- Display correctly between mobile and desktop.
- Resolved issue with Accessibility so now get 100% across all aspects.

With dynamic images, site is now 4MB in size, or **0.53**% of the WordPress data size; 4% of WordPress static size.

**Update Oct 2025**
More updates and streamlining.  I now have:
 - Website built into a docker container (incl web server).
 - Minifying HTML, CSS and JS code - reduces network bandwidth.
 - Compressing all assets with gzip and brotli using highest compression during build and stored in docker image - reduces network bandwidth.
 
So, with these changes, network bandwidth is significantly reduced.  The size has now increased to around 9MB due to storing different formats of images (10% of WordPress static size, but network bandwidth significantly reduced).
## Conclusion
Eleventy for the win.  For the amount of blogs that I write, the size that it takes up, and the less issues of someone trying to hack me...its worth it!
