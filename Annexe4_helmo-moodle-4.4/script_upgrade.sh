#!/bin/bash

# When started for the first time, the script will fail because the database does not exist.
# Therefore, we disable error management and enforce the return of 0

#set -eu
 
php /var/www/html/admin/cli/upgrade.php
exit 0