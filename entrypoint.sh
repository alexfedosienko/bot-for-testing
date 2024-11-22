#!/bin/sh

set -e

ln -sf /dev/stdout /var/log/apache2/access.log
ln -sf /dev/stdout /var/log/apache2/error.log

exec httpd -D FOREGROUND