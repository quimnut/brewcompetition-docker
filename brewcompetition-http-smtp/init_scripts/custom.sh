#! /bin/bash
# put persistant changes in here if you need them.

# you can increase logging by changing this.
sed -i "s/define('TESTING'.*/define('TESTING', FALSE);/" /var/www/html/paths.php 
sed -i "s/define('DEBUG'.*/define('DEBUG', FALSE);/" /var/www/html/paths.php 
sed -i "s/define('DEBUG_SESSION_VARS'.*/define('DEBUG_SESSION_VARS', FALSE);/" /var/www/html/paths.php 

# old bug 
# sed -i "s/))))/)))/" /var/www/html/includes/process/process_users_register.inc.php

# overwite club array
#sed -i s'/^\$club_array =.*/\$club_array = array("Western Suburbs Amateur Wine Guild|Western Suburbs Amateur Wine Guild","Toowoomba Society Of Beer Appreciation (TooSOBA)|Toowoomba Society Of Beer Appreciation (TooSOBA)","Small Batch Home Brew Club|Small Batch Home Brew Club","SaD Brewers|SaD Brewers","Pine Rivers Underground Brewing Society (PUBS)|Pine Rivers Underground Brewing Society (PUBS)","Mackay And District (MAD) Brewers|Mackay And District (MAD) Brewers","Ipswich Brewers Union (IBU)|Ipswich Brewers Union (IBU)","GoldCLUB|GoldCLUB","Fraser Coast Bayside Brewers|Fraser Coast Bayside Brewers","Central Queensland Craft Brewers (CQCB)|Central Queensland Craft Brewers (CQCB)","Brisbane Brewers Club (BBC)|Brisbane Brewers Club (BBC)","Brisbane Amateur Beer Brewers (BABBS)|Brisbane Amateur Beer Brewers (BABBS)");/' /var/www/html/includes/constants.inc.php

# disable mysql strict mode as it fails hard on quick adding participants at least with an imported database.
cat << EOF > /etc/mysql/conf.d/disable_strict_mode.cnf
[mysqld]
sql_mode=IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
EOF

# supress php warning
mkdir -p /var/www/html/classes/htmlpurifier/standalone/HTMLPurifier/DefinitionCache/Serializer
chown www-data.www-data /var/www/html/classes/htmlpurifier/standalone/HTMLPurifier/DefinitionCache/Serializer


