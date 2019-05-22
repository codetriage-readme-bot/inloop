#!/bin/sh
if [ ! -z "$ENABLE_HTMLCHECKS" ]; then
    exec java -Dnu.validator.servlet.bind-address=127.0.0.1 -cp lib/vnu-18.11.5.jar \
        nu.validator.servlet.Main 8888
fi
sleep 1111111111111
