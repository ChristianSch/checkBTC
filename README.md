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


Version 1.0.1
--------------
Initial release.

TODO
====
* Version 1.1
	* get data from MtGox
		* adapt currencies in preferences (with full name)
	* show warning icon (add menu item to show the exact error, i.e. "no internet connection available") and add menu item on top (like the network symbol in OSX does)
	* start at login
		* should make own controller for that because of syncing. maybe a **user defaults controller** in general? (https://github.com/Mozketo/LaunchAtLoginController)
			* make controller
	* clean up preferences.xib
		* build up the popUpButtons programaticly
	* animate course
		* implement abillity to switch between animation/no animation
	* show actual bitcoin icon instead of "BTC"
		* maybe optional: XBT or BTC or logo

* Version 1.2
	* preferences: use real user defaults, not the last entered (neccessary because of the 10.0 minimum of the refresh rate)
	* preferences: add possibility to choose formating

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
