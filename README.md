SafeBrowsing4OTRS
=================

SafeBrowsing4OTRS is an OTRS module to check the articles of your tickets against the Google Safe Browsing database for potential malware and phishing links.

Feature List
------------
### Google Safe Browsing database
The Google Safe Browsing database is used by Google to warn users about potentially unsafe websites that deliver
malware or are some kind of phishing website. These information are used in the Google search results and also
in the Google Chrome browser or Mozilla Firefox browser, if you try to vitis such a website.

This OTRS module uses the Google Safe Broswing database to warn the agents about potentially unsafe links or
URLs in articles of OTRS tickets, e.g. incoming emails of clients or spam.

### Warnings shown in the TicketZoom
The module checks the links and URLs in the ticket articles and shows a warn message if any of the checked websites
are found in the Google Safe Browsing database. The module does not prevent the agent from clicking the link and
visiting the website!

Please be aware of the fact, that sometimes the database has false entries of websites that are completely safe but
are listed as unsafe. Visiting all links and using this module for information about potentially unsafe websites is
at your own risk.

To always have the latest database updates, the results of a check are not cached in the OTRS database. The module
needs an active internet connection on the OTRS server to connect to the Google database.

System Requirements
-------------------
### Framework
The following OTRS framework is required:
OTRS Version 4.0.x.

### Google Safe Browsing database API key
In order to get access to the Google Safe Browsing database, you need an API key. This API key is for free.
You can get your API key here: [https://developers.google.com/safe-browsing/key_signup](https://developers.google.com/safe-browsing/key_signup)

Installation
------------
The following instructions explain how to install the package.


### Admin Interface
Please use the following URL to install the package utilizing the admin interface (please note that you need to be in the admin group).
http://localhost/otrs/index.pl?Action=AdminPackageManager

**Note:** OTRS will warn you about a failed package verification. You can continue the installation without any
security risks. In the future, this module might be verified by OTRS.


### Command Line
Whenever you cannot use the Admin Interface for whatever reason, you may use the following command line tool
("bin/otrs.PackageManager.pl") instead.
`shell> bin/otrs.PackageManager.pl  -a install -p /path/to/$Name-$Version.opm`

Configuration
-------------
The package can be configured via the SysConfig in the Admin Interface. The following configuration options are available:

### SafeBrowsing::Active
*Group: SafeBrowsing4OTRS, Subgroup: Settings.*
Activates Safe Browsing feature.

### SafeBrowsing::APIKey
*Group: SafeBrowsing4OTRS, Subgroup: Settings.*
The Google Safe Browsing API key. You can get your API key here: [https://developers.google.com/safe-browsing/key_signup](https://developers.google.com/safe-browsing/key_signup).

### SafeBrowsing::CheckOnlyExternalMessages
*Group: SafeBrowsing4OTRS, Subgroup: Settings.*
Only check incoming messages for potentially unsafe links and URLs.

### SafeBrowsing::FadeOutMessage
*Group: SafeBrowsing4OTRS, Subgroup: Settings.*
If the module does not find any potentially unsafe links and URLs, fade out the info message after some seconds.

### SafeBrowsing::FadeOutTime
*Group: SafeBrowsing4OTRS, Subgroup: Settings.*
The number of milliseconds to wait until the message will be faded out (1000 milliseconds = 1 second).

OPM package files
-----------------
OPM package files can be found:

- on Github: [https://github.com/zottto/SafeBrowsing4OTRS](https://github.com/zottto/SafeBrowsing4OTRS)
- on OPAR: [http://opar.perl-services.de/dist/SafeBrowsing4OTRS-1.0.0](http://opar.perl-services.de/dist/SafeBrowsing4OTRS-1.0.0)

License
-------
GNU AFFERO GENERAL PUBLIC LICENSE Version 3, November 2007

Contact
-------
Marc Nilius, otrs@marcnilius.de, [www.marcnilius.de](http://www.marcnilius.de)