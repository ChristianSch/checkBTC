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
	* saving of chosen plugin
	* setting the bundle when changed in preferences
	* inverse text color when highlighted (statusBarItem)
	* test plugins with all available currencies
	* fallback plugin when chosen plugin does not exist
		* search for plugin which can handle the currency the user set as default
		* display popover for notice

* Version 1.1.1
	* custom about window (the default is such an ugly one)
	* API should provide methods of validation for key/value pairs (i.e. minimal refresh rate the api needs, valid currency values for user defaults etc.). these must be available globally!

* Perspectives:
	* github page
	* jenkins/travis-ci continuous integration
	* https://www.plcrashreporter.org - crash reporter
		* MIT license compatible?
	* HUD with graph (hour/day/week/month?) and extended information
		* http://blog.dreamcss.com/dev-tools/charts/core-plot-cocoa-plotting-framework/ (BSD License!)
	* anonymous system stats (i.e. which exchange is used how often?)
