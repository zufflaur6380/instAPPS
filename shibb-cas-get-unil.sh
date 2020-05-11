#!/bin/sh
# Adapted from https://gist.github.com/olberger/d34253822a84664648b3
######################################################################

#Authentication details
USERNAME="lzuffer1"
PASSWORD="LZMZYLZ0816"

# Complete URL of the resource behind Shibboleth
DEST="https://www2.unil.ch/Shibboleth.sso/Login?entityID=https%3A%2F%2Faai.unil.ch%2Fidp%2Fshibboleth&target=https%3A%2F%2Fwww2.unil.ch%2Fsoftunil%2Fadobeserializer%2Fsallesinfos%2Fadobe_allapps_salles_win_fr_FR_WIN_64.zip"

SP=https://www2.unil.ch/Shibboleth.sso/Login
#IDP="https://aai.unil.ch/idp/profile/SAML2/Redirect/SSO?execution=e1s1"
IDP="https://aai.unil.ch/idp/profile/SAML2/Redirect/SSO?execution=e1s1"

#Temporary files used by curl to store cookies and http headers
COOKIE_JAR=.cookieJar
HEADER_DUMP_DEST=.headers
rm -f $COOKIE_JAR
rm -f $HEADER_DUMP_DEST

#The script itself is below

# 1. connect to the page which will display the WAYF

# echo "Step 1:"
# echo "curl -L -s -k -c $COOKIE_JAR -D "$HEADER_DUMP_DEST" -o /dev/null" "$DEST"

curl -L -s -k -c $COOKIE_JAR -D "$HEADER_DUMP_DEST" -o /dev/null "$DEST"

# echo "----------------------------------------------"

# 2. Submit the login form, using the cookies saved in the cookie jar. We keep the headers from this request as the return value should be a 302 including a "ticket" param which we'll need in the next request

# echo "Step 2"
# echo "curl -k --data-urlencode "j_username=$USERNAME" --data-urlencode "j_password=$PASSWORD" --data-urlencode "_eventId=proceed" -i -b $COOKIE_JAR -c $COOKIE_JAR -o file.html" $IDP

curl -k --data-urlencode "j_username=$USERNAME" --data-urlencode "j_password=$PASSWORD" --data-urlencode "_eventId=proceed" --data-urlencode "submit=_eventId_proceed" -i -b $COOKIE_JAR -c $COOKIE_JAR -o file.html $IDP

# echo "----------------------------------------------"

# 3. Extract the SAMLResponse and RelayState from the page and submit it

# echo "Step 3"

grep 'name=.SAMLResponse' file.html | sed 's/.*value..//' | sed 's/\".*//' > samlresponse.txt
relaystate=`grep 'name=.RelayState' file.html | sed 's/.*value..//' | sed 's/\".*//' | perl -MHTML::Entities -le 'while(<>) {print decode_entities($_);}'`
target=`grep 'form action.' file.html | sed 's/.*action..//' | sed 's/\".*//' | perl -MHTML::Entities -le 'while(<>) {print decode_entities($_);}'`

# Post the form and get redirected to the page
# echo "curl -L -k --data "RelayState=$relaystate" --data-urlencode SAMLResponse@samlresponse.txt -i -b $COOKIE_JAR -c $COOKIE_JAR "$target" > $PID.pdf"

curl -L -k --data "RelayState=$relaystate" --data-urlencode SAMLResponse@samlresponse.txt -i -b $COOKIE_JAR -c $COOKIE_JAR "$target" > adobe_allapps_salles_win_fr_FR_WIN_64.zip

# echo "----------------------------------------------"