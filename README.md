Final Payment
=============

This becomes a Rails app supporting the chargeback among users participating in an event paying for different things...

Development
===========

  * Run rake db:seed to fill the database with example data
  * Events can be created by Users, with regard to that, check Event.owner and
    User.events (yes, thats basic rails association stuff)
  * [ImageMagick](http://www.imagemagick.org) needs to be installed (for bill uploads)
