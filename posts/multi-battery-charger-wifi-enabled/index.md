---
title: "Multi Battery Charger - WiFi enabled"
date: 2023-08-18
tags: 
  - "electronics"
  - "smart-home"
description: "Creating a multi battery charger switch to charge multiple batteries in succession"
author: "Me"
---

## Overview

This project is about creating a multi battery charger that is smart enabled.  The circuit allows up to 8 batteries to be charged from a single battery charger.  When the battery charger is started, it starts charging one battery at a time, until all batteries have been charged.  At this point, the battery charger will turn off.

Features of the charger

- Multiple batteries can be charged
- Auto turn off when completed
- Automatic changing to next battery when charged
- Capable to handling 30A charge current
- Simple interface
- Voltage/Current display
- Built with ESPHome
- WiFi Enabled - allow to be integrated into Home Assistant
- Bring your own charger - This device just switches between batteries, it is not responsible for the type of battery connected

### Components

- 8 Channel WiFi enabled relay board

### Inputs / Output

**Inputs**

- On/Off button
- Start/Pause button
- Next/Stop button
- Current - ADC connection

**Outputs**

- 8 Relay outputs
- 8 LED's showing relay status
- _Running_ LED
- Charger relay on/off
- Unit on LED

**Connections**

- _Running_ LED connected to the Charger relay on/off output
- 8 LED outputs added as an extension on the built in HC595 serial/parallel converter
- Current through the ADC pin
- Unit On LED - on when power to the unit

### Using the Device

The device is designed to be easy to control.  There are only two buttons on the front of the unit that are required to use the unit.  Not all configuration settings are available through the device interface, and require home assistant to configure.

**To Power On the Device**

The device uses soft-power on.  Using the switch on the back of the unit will enable power to the unit.   In this initial state, power is supplied to the unit, but the unit is not fully turned in.  In the state, the unit can connect to Wi-Fi and communicate to Home Assistant.  This will enable schedules to be executed as required, as well as over-the-air updates.

Pressing and holding the On/Off button for 2 seconds and then releasing will turn the unit on, if the power switch is on.  The unit will go through a start up sequence:

- All lights on
- Display of the maximum batteries configuration option (and allow adjustment)
- If the configuration option _Auto Start Charging_ is enabled, the device will start charging battery one, otherwise the unit will be in Idle mode.

**To Power Off the Device**

Press and hold the On/Off switch for approximately 2 seconds.

**To Change Current Selected Battery**

Use the _Next/Sel_ button repeatedly to change the selected battery to the desired battery.  If a battery is currently charging, the unit will start to flash the _charging_ LED.  Once a timeout of selecting the battery has occurred, approximately 2 seconds, the battery will change to the selected battery and start charging.  If you want to cancel changing battery selection if the charger is on, ensure to select the current battery that is charging.

**To Start and Pause Charging**

To start charging batteries, press the Start/Pause button.  The LED on the Next/Sel button will illuminate showing that the battery charger is turned on.  If the charger outputs are connected to the multi-battery charger, the Voltage/Current display will also illuminate.  To pause the charging, press the Start/Pause button again.  The display will turn off, along with the light on the Next/Sel button as the charger is turned off, and the battery relay of the selected battery is turned off.

### Configuration

The device has a number of configuration options.  Due to the hardware only have 2 switches, the device configuration on the unit is limited.  The changes can be made through a home-assistant setup.

The following table describes the configuration options, and whether they can be configured on the device, or in home assistant.

|Configuration Option|On Unit|In HA|Default Value|Description|
|---|---|---|---|---|
|Auto Start Charging|No|Yes|No|When power is turned onto the battery charger, it will automatically start the charging process|
|Calibration Value|No|Yes|918|Used to zero the current out. See calibration section.|
|Charger off when switching Battery|No|Yes|Yes|When the unit is switching to another battery, should the charger be turned off as well during the switch.|
|Delay when changing battery|No|Yes|2s|The number of seconds between disabling the current battery selected relay, and energising the new battery selection.|
|Max Batteries|Yes|Yes|5|The maximum number of batteries to charge|
|Restart Device|No|Yes|N/A|Used to restart the device remotely|
|Switch Current|No|Yes|0.04 A|The maximum current that the battery charger is supplying before switching to the next battery.|

#### Auto Start Charging

When this setting is enabled, whenever the unit is turned on, it will automatically start charging.

#### Calibration Value

The calibration value is used to offset the current reading sensor of the microprocessor.  When the unit is switched on, and not drawing any current, the current reading on Home Assistant may show current being drawn.  This setting does not affect the built in display of the unit.  The calibration slide switch is moved until the _Charge Current_ reading is zero (0).  The calibration value shown is the raw A/D value read by the microprocessor.

Adjust procedure

- Connect the charger to the unit.
- Turn on the multi-battery charger.
- Note, and adjust the _Switch Current_ configuration sensor to 0.
- Press the _Start/Pause_ button to start the charging process.
- Wait 30 seconds, and make note of the _charge current_ sensor value.
- Work out the new value of the _calibration value_: calibration value - ( charge current / 0.04).
- Adjust the _calibration value_ configuration slider to the new value.
- Wait 30 seconds and confirm that the _charge current_ now sits at zero.  Adjust slider as necessary.
- Once satisfied, adjust the _Switch Current_ to the desired amount.

NOTE: Adjust the value just enough so that it continuously displays 0.  The software will not display negative numbers, so it is possible to set a value such that the current read is a negative value.  However the display will only show 0.  If the unit is configured like this, the current reading will not show current draw until the negative difference has been exceeded, as which point the display will register.  In other words, the negative value of current reading is the error amount in the current reading.

**Charger Off when Switching Battery**

When the current has fallen below the _Switch Current_ value for an extended time, the unit will switch battery.  The relay for the selected battery will turn off disconnecting the charger from the battery.  This option enables the charger relay to also be turned off at the same time.  This setting will depend upon the battery charger.  Some smart battery chargers, when a fault is detected with the battery, requires that the charger is turned off to reset, instead of just disconnecting the battery.  Should the option not be set, and a charger enters a fault condition, subsequent batteries will not be charged.

**Delay when Changing Batteries**

This options sets the time, in seconds between when a battery is disconnected from the charger, and when the next battery is connected.  If the _Charger Of when Switching Battery_ is enabled, this setting will also effect the amount of time the charger is switched off.

**Maximum Batteries**

This sets the maximum number of batteries connected to the charger.  This settings will enable the device to turn off quicker, as it does not need to try and charge batteries that are not connected.  This can be changed anytime from Home Assistant, but can only be changed during power-on on the device.

To change the Maximum Batteries on the device:

- Turn the unit off if already on (not Battery lights displayed)
- Turn the unit on.
- The first stage of initialization is ALL lights are enabled.
- When the lights on the buttons go out, the unit is displaying the maximum batteries.
- Use the Next/Select button to change the number of lights on, which represents the maximum number of batteries.  You have approximately 5 seconds to press the Next/Select button to start changing the number of batters.
- After approximately 5 seconds of no button selection, the unit will move to the on state, where battery 1 is illuminated.

**Restart Device**

This enables the device to be reset from Home Assistant.  This is best used prior to upgrading the firmware.

**Switch Current**

Sets the continuous value that the average charge current must be at, or below before the unit will switch batteries.  This is in effect the maximum current that is drawn by a battery when it is charged.  The average must be at or below this value for 3 consecutive readings of the _Charge Current_ sensor.

### Pin Outs for the Charger

|ESP-12 Pin|Function|
|---|---|
|IO 0||
|IO 2|On/Off Start/Pause Button|
|IO4|Next Button|
|IO 5|595 Relay OE pin|
|IO 12|595 Relay Latch Pin|
|IO 13|595 Relay Latch Clock Pin|
|IO 14|595 Relay Data Pin|
|IO 15|Charger Relay|
|IO 16|Status LED|

### Relay control

The board comes with an HC595 controlling the relays.  The pin-outs are hard coded.  The following table shows the pins that are used on the ESP32, along with the connections to the chip

|ESP-12 Pin|Function|74HC595 Pin|ESPHome name|
|---|---|---|---|
|5|!OE|13|oe_pin|
|12|RCLK|12|latch_pin|
|13|SRCLK|11|clock_pin|
|14|SER|14|data pin|
