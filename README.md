checkBTC
========

Display the Bitcoin course in the status bar of OS X. Version 1.0.1

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
x	* get data from MtGox
	x	* adapt currencies in preferences (with full name)
x		* implement dataManager that holds the connectionManager and has the
		statusbaritemcontroller as a delegate for refreshing the course and displaying
		errors
x			* implement statusBarController
x	* start at login
x		* should make own controller for that because of syncing. maybe a
x		**user defaults controller** in general?
x			* distinguish userDefaultsController and preferencesController (merge? diverse?)
x		(https://github.com/Mozketo/LaunchAtLoginController)
x	* animate course
(?)		* the menuItem should have a fixed space because of nasty redraws when the
		animation starts
x	* connection manager
x		* warning if no connection is available
x	* clean up appDelegate
	* -color: as property, overwriting the getter/setter in StatusBarItemController
	* add -cleanup to DataManager that gets called on applicationWillTerminate to
	invalidate timer

* Version 1.2
(x)	* in general: expand the preferencescontroller to a full "user defaults manager",
	providing a default set of user defaults, managing access, aggregation/generation of
	preferences interface etc. (should create the whole thing programaticly)
	* preferences: provide app with default user defaults as file and initiate them
	correctly
	* clean up preferences.xib
		* build up the popUpButtons programmatically
	* add prossibility to choose between XBT/BTC/Bitcoin icon, "." or ",", various numbers of decimal places
	* preferences: switch off animation
	* generate documentation and maintain github page
	* 
* Version 1.2
	* API plugin system (!!!)
		-> https://developer.apple.com/library/mac/documentation/cocoa/Conceptual/LoadingCode/Tasks/UsingPlugins.html#//apple_ref/doc/uid/20001276-CJBDDCAB
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

FAQ
===

Q: The app does not show any course, instead it only displays "CheckBTC"!?
---------------------------------------------------------------------------
**A**: This behavior is typical if the app could not get data from the internet. Either the internet connection is down (or blocked from a firewall like Little Snitch) or blockchain.info is temporarly down. If there is no update available feel free to contact me at <christian.schulze@mni.thm.de>.
