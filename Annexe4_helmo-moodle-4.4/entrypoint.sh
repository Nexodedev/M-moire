#!/bin/bash
set -eu

# "Run Migration script"
/usr/local/bin/script_upgrade.sh

# "Start apache"
apache2-foreground