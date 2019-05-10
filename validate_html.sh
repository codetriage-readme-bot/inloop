#!/usr/bin/env bash

pipenv run honcho start &

LOGIN_URL=https://localhost:8000/login/
USERNAME="admin"
PASSWORD="secretsecret"
COOKIE_FILE=cookies.txt
CURL_BIN="curl -s -c $COOKIE_FILE -b $COOKIE_FILE -e $LOGIN_URL"

echo "Obtaining CSRF token..."
${CURL_BIN} ${LOGIN_URL} > /dev/null
CSRF_MIDDLEWARE_TOKEN="csrfmiddlewaretoken=$(grep csrftoken $COOKIE_FILE | sed 's/^.*csrftoken\s*//')"

echo "Logging in..."
${CURL_BIN} \
    -d "$CSRF_MIDDLEWARE_TOKEN&username=$USERNAME&password=$PASSWORD" \
    -X POST ${LOGIN_URL}

echo "Performing tests..."
${CURL_BIN} \
    -d "$CSRF_MIDDLEWARE_TOKEN&..." \
    -X POST https://localhost:8000/tasks

echo "Removing cookies file..."
rm ${COOKIE_FILE}
