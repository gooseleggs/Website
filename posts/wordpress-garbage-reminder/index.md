---
title: "Home Assistant -  Garbage Reminder"
date: 2023-12-31
tags: 
  - "smart-home"
author: "Me"
description: "Creating a reminder for which week each bin is put out"
---

# Overview

This post describes how I made a garbage reminder that changes every week.  In my area, rubbish collection is on a two week cycle as per the following table

| |Week 1|Week2|
|---|---|---|
|Monday|Recycling / Council Rubbish||
|Tuesday|Glass|Green waste / Rubbish Bin|

There has been some changes to what Home Assistant (HA) can provide, so this is all being done using the native options, without relying on third party plugins.  This solution allows for an image to change depending upon the week.  There are three components to make this solution

1. Toggle switch is the brains of the system
2. Picture card - displays an image depending upon the position of the toggle switch
3. Calendar event - toggles the switch when an event occurs.

## Toggle Switch

Lets get the brains of this solution configured first

- Go to **Settings > Devices and Services > Helpers**
- Create a **new helper** of type **Toggle**
- I have called my _Recycle Week_ and when turned on represents week 1 of my schedule
- Make note of the entity ID as we will need this (input\_boolean.recycle\_week).
- Set the toggle to on to represent the first week

# Picture Card

Now we have our toggle switch, lets now get the picture card working, and then we can toggle the switch as required and confirm all works as expected.  For this blog, I have used two random pictures to represent each week.  Later I will update these to represent actual pictures of what I want.

I did this with XML code.  Not sure if you can do this with built in editor.

1. Switch to a dashboard where you want the card to be displayed
2. Click the **Add Card** button
3. Select **Picture Entity**
4. Select the **Show code editor** entity
5. Replace the XML with the code below
6. Make modifications as follows:
    1. Set the input\_boolean value as created above
    2. Change the photos URL (see below)
7. Click **Save**

```xml
type: picture-entity
entity: input_boolean.recycle_week
show_name: false
show_state: false
state_image:
  'on': >-
    https://images.unsplash.com/photo-1682686581551-867e0b208bd1?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHx8
  'off': >-
    https://images.unsplash.com/photo-1703555508141-4397207fc6d2?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1fHx8ZW58MHx8fHx8
tap_action: none
```

## Testing Image Toggling

On the same dashboard

1. Press **Add Card**
2. Change tab to **By Entity**
3. Search or scroll and find _Recycle Week_ entity
4. Put a tick in the checkbox next to it
5. Press **Continue**
6. Press **Add to Dashboard**
7. Toggle the slide switch of _Recycle Switch_ card and the image in the picture card should change.
8. Once satisfied that this works, then delete the _Recycle Week_ toggle card if desired.

Note: We are only temporarily putting this on the dash board for us to test with.  Once working, then we can remove this card.

# Calendar

## Recurring event

If you do not have the local calendar integration installed, then you need to go into settings and install it.  This will allow us to create a recurring schedule entry.

Create a new calendar (I have called mine Automations) where we are going to put into the repeating event.

Add a repeating calendar event, weekly.  Since I have a Monday/Tuesday collection, I have made the event occur at 4:30pm on a Tuesday.  I have chosen then, as by 4:30 on a Tuesday it is too late to put out the Rubbish, and then from Wednesday onward, it is correct.  However, chose a time that suits yourself.  Make a note of the name of the event you created, as we need this later - my event is called _Change Recycling Week_

Set the duration of the calendar event to 1 minute.  We are only going to be reacting to the start of the event.

## Automation

Now we have an event that is recurring, we now need to set up and automation that fires when the calendar event starts.

1. Go to Settings > Automations & Scenes
2. Under the Automations tab, select **Create Automation**
3. Select _Create a new automation_
4.  Under Triggers, select Add Trigger
5. Select Calendar
6. Select the calendar that has the trigger event
7. Leave the rest of the trigger options as default
8. Add a condition
9. Select _Template_
10. add the following in, changing the value on the right hand side to equal what the calendar event is called: {% raw %} `{{ trigger.calendar\_event.summary == 'Test Event' }}` {% endraw %}
11. Add an Action
12. select: **Call a service**
13. Select: **Input Boolean: Toggle**
14. Select the entity we created: Recycle Week
15. Click Save
16. Give it a name, for example: _Automation: Change Recycle Week_
17. Click **Save**

## Testing it all out

Change the calender event time to be > 15 minutes from now (HA only reads the calendar every 15 minutes).  Make a note of the setting of the switch, and then see if it changes when the time elapses.
