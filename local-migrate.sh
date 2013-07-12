#!/bin/bash

APPLICATION_ENV=jvogt
mongo CB --eval "db.dropDatabase();"
#sudo rm -rf ~/site-temp ~/planner-temp
#/var/www/platform/scripts/cb export v3 sites 229776 --with-profiles --faux ~/site-229776
#/var/www/platform/scripts/cb export v3 sites 143137,229776,180612,272236,700949,709057 --with-profiles --faux ~/site-temp
#/var/www/platform/scripts/cb export planners 27305 --with-profiles ~/planner-temp
sudo rm -rf /var/www/platform/public/assets/ugc/*
/var/www/platform/scripts/cb import ~/site-temp-bak
/var/www/platform/scripts/cb import ~/planner-temp-bak
sudo /etc/init.d/memcached restart
sudo chmod -R 777 /var/www/platform/public/assets/ugc
sudo chown -R apache:apache /var/www/platform/public/assets/ugc
#/var/www/platform/scripts/cb migrate execute Indexes
/var/www/platform/scripts/cb migrate execute ContentPages
/var/www/platform/scripts/cb migrate execute Partner
/var/www/platform/scripts/cb migrate execute AdminUsers
/var/www/platform/scripts/cb migrate execute Email
mongo CB --eval "db.worker.insert({'_id':'http://jvogt.caringbridge.org'});"
mongo CB --eval 'db.site.update({"_id":143137}, {$set: {"theme.id": "hope"}} );'
mongo CB --eval 'db.site_profile.update({siteId:229776,userId:6527825}, {$set:{isPrimary:"1"}})'
mongo CB --eval 'db.site_profile.update({siteId:1,userId:6527825}, {$set:{isPrimary:"1",role:"Organizer"}})'
mongo CB ~/cb-indexes.js
