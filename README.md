checkBTC
========

Display the current market price of Bitcoins in the status bar of OS X. 

Changelog
=========
Version 1.1
-----------
* A timestamp of the last data refresh is shown as a tooltip of the menuItem
* data is now retrieved from MtGox
* animation of course change is now available
* an error is displayed if there where any failures while connecting to the internet

Version 1.0.1
--------------
Initial release.

TODO
====
* Version 1.1
 	* plugin system (!!!)
		-> https://developer.apple.com/library/mac/documentation/cocoa/Conceptual/LoadingCode/Tasks/UsingPlugins.html#//apple_ref/doc/uid/20001276-CJBDDCAB
		* plugin controller
		* kraken as default plugin -> https://www.kraken.com/help/api#general-usage
	* the menuItem should have a fixed space because of nasty redraws when the animation
	starts
	* -color: as property, overwriting the getter/setter in StatusBarItemController
	* update the documentaion (remove @abstract etc.)
		* example of good doc:
		https://github.com/AFNetworking/AFNetworking/blob/master/AFNetworking/AFHTTPSessionManager.h
	* in general: expand the preferencescontroller to a full "user defaults manager" (done),
	providing a default set of user defaults, managing access, aggregation/generation of
	preferences interface etc. (should create the whole thing programaticly)
		* really save the preferences (UserDefaultsController -setUserDefaults:data !!!)
	* preferences: provide app with default user defaults as file and initiate them
	correctly
	* clean up preferences.xib
		* build up the popUpButtons programmatically
	* add prossibility to choose between XBT/BTC/Bitcoin icon, "." or ",", various numbers of decimal places
	* preferences: switch off animation
	* generate documentation and maintain github page

* Version 1.2
	* custom about window (the default is such an ugly one)
	* the data source (market place) can be chosen
	* API should provide methods of validation for key/value pairs (i.e. minimal refresh rate the api needs, valid currency values for user defaults etc.). these must be available globally!
		* API protocol and controller

* Perspectives:
	* https://www.plcrashreporter.org - crash reporter
		* MIT license compatible?
	* HUD with graph (hour/day/week/month?) and extended information
		* http://blog.dreamcss.com/dev-tools/charts/core-plot-cocoa-plotting-framework/ (BSD License!)
	* anonymous system stats
