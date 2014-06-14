checkBTC
========

Display the current market price of Bitcoins in the status bar of OS X. 

PLEASE NOTE: This project will be discontinued as of the 14th June 2014. The upcoming release of OS X 10.10 Yosemite introduces a way better user experience for this type of apps. The today extensions for the notification center are a much better way of displaying bitcoin prices (even for several marketplaces at once). So I stop developing CheckBTC at this point. If you want to use the code or continue this project, please go ahead and do so.

I'll merge the development branch with the master branch. If you want to continue development please note the following: the open tickets could be seen as a todo list. My next step would be to introduce a notification system that notificates every component that depends on the exchange plugins on plugin changes.

Just ask if anything remains unclear.

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

* Perspectives:
	* jenkins/travis-ci continuous integration
	* https://www.plcrashreporter.org - crash reporter
		* MIT license compatible?
	* HUD with graph (hour/day/week/month?) and extended information
		* http://blog.dreamcss.com/dev-tools/charts/core-plot-cocoa-plotting-framework/ (BSD License!)
	* anonymous system stats (i.e. which exchange is used how often?)
