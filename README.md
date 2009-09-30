Integrity Heroku
================

Deploy [Integrity](http://integrityapp.com) on [Heroku](http://heroku.com)'s platform.

    git clone git://github.com/sr/integrity-heroku
    cd integrity-heroku
    heroku create
    git push heroku master
    heroku rake db
    heroku open
