checkBTC
========

Display the current market price of Bitcoins in the status bar of OS X. 

Changelog
=========
Version 1.1
-----------
* A timestamp of the last data refresh is shown as a tooltip of the menuItem
* data is now retrieved from several exchanges via a plugin system
* animation of course change is now available
* an error is displayed if there where any failures while connecting to the internet

Version 1.0.1
--------------
Initial release.

TODO
====
* Version 1.1
	* -color: as property, overwriting the getter/setter in StatusBarItemController
	* really save the preferences (UserDefaultsController -setUserDefaults:data)
	* preferences: provide app with default user defaults as file and initiate them
	correctly
	* generate documentation and maintain github page

* Version 1.1.1
	* custom about window (the default is such an ugly one)
	* API should provide methods of validation for key/value pairs (i.e. minimal refresh rate the api needs, valid currency values for user defaults etc.). these must be available globally!

* Perspectives:
	* https://www.plcrashreporter.org - crash reporter
		* MIT license compatible?
	* HUD with graph (hour/day/week/month?) and extended information
		* http://blog.dreamcss.com/dev-tools/charts/core-plot-cocoa-plotting-framework/ (BSD License!)
	* anonymous system stats (i.e. which exchange is used how often?)
