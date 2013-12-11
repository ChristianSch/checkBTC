checkBTC
========

Display the Bitcoin course in the status bar of OS X. Version 1.0.

TODO
====
* Version 1.1
	* get currencies from tracker, not pre-coded
	* preferences: use real user defaults, not the last entered (neccessary because of the 10.0 minimum of the refresh rate)

* Perspectives:
	* https://www.plcrashreporter.org - crash reporter
		* MIT license compatible?
	* sign releases without dev account (pem?)
	* HUD with graph (hour/day/week/month?) and extended information
		* http://blog.dreamcss.com/dev-tools/charts/core-plot-cocoa-plotting-framework/ (BSD License!)

FAQ
===

Q: The app does not show any course, instead it only displays "CheckBTC"!?
---------------------------------------------------------------------------
**A**: This behavior is typical if the app could not get data from the internet. Either the internet connection is down (or blocked from a firewall like Little Snitch) or blockchain.info is temporarly down. If there is no update available feel free to contact me at <christian.schulze@mni.thm.de>.
