#!/usr/bin/env bash
URLBASEORIG="https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyBAJ8AZgyG_dD62kAjWdlqYc5PSRnML2Gw&location=37.774800,-122.435629&radius=50000"
URLBASE=$URLBASEORIG
echo "NEXT URL $URLBASE"
RESPONSE=$(curl "$URLBASE")
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)

sleep 3

URLBASE="$URLBASEORIG&pagetoken=$NEXTPAGE"
echo "NEXT URL $URLBASE"
RESPONSE=$(curl $URLBASE)
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)

sleep 3

URLBASE="$URLBASEORIG&pagetoken=$NEXTPAGE"
echo "NEXT URL $URLBASE"
RESPONSE=$(curl $URLBASE)
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)



URLBASEORIG="https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyBAJ8AZgyG_dD62kAjWdlqYc5PSRnML2Gw&location=37.800441,-122.410712&radius=50000"
URLBASE=$URLBASEORIG
echo "NEXT URL $URLBASE"
RESPONSE=$(curl "$URLBASE")
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)

sleep 3

URLBASE="$URLBASEORIG&pagetoken=$NEXTPAGE"
echo "NEXT URL $URLBASE"
RESPONSE=$(curl $URLBASE)
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)

sleep 3

URLBASE="$URLBASEORIG&pagetoken=$NEXTPAGE"
echo "NEXT URL $URLBASE"
RESPONSE=$(curl $URLBASE)
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)



URLBASEORIG="https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyBAJ8AZgyG_dD62kAjWdlqYc5PSRnML2Gw&location=37.761439,-122.426276&radius=50000"
URLBASE=$URLBASEORIG
echo "NEXT URL $URLBASE"
RESPONSE=$(curl "$URLBASE")
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)

sleep 3

URLBASE="$URLBASEORIG&pagetoken=$NEXTPAGE"
echo "NEXT URL $URLBASE"
RESPONSE=$(curl $URLBASE)
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)

sleep 3

URLBASE="$URLBASEORIG&pagetoken=$NEXTPAGE"
echo "NEXT URL $URLBASE"
RESPONSE=$(curl $URLBASE)
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)



URLBASEORIG="https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyBAJ8AZgyG_dD62kAjWdlqYc5PSRnML2Gw&location=37.757541,-122.486427&radius=50000"
URLBASE=$URLBASEORIG
echo "NEXT URL $URLBASE"
RESPONSE=$(curl "$URLBASE")
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)

sleep 3

URLBASE="$URLBASEORIG&pagetoken=$NEXTPAGE"
echo "NEXT URL $URLBASE"
RESPONSE=$(curl $URLBASE)
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)

sleep 3

URLBASE="$URLBASEORIG&pagetoken=$NEXTPAGE"
echo "NEXT URL $URLBASE"
RESPONSE=$(curl $URLBASE)
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)



URLBASEORIG="https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyBAJ8AZgyG_dD62kAjWdlqYc5PSRnML2Gw&location=37.785523,-122.476970&radius=50000"
URLBASE=$URLBASEORIG
echo "NEXT URL $URLBASE"
RESPONSE=$(curl "$URLBASE")
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)

sleep 3

URLBASE="$URLBASEORIG&pagetoken=$NEXTPAGE"
echo "NEXT URL $URLBASE"
RESPONSE=$(curl $URLBASE)
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)

sleep 3

URLBASE="$URLBASEORIG&pagetoken=$NEXTPAGE"
echo "NEXT URL $URLBASE"
RESPONSE=$(curl $URLBASE)
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)



URLBASEORIG="https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyBAJ8AZgyG_dD62kAjWdlqYc5PSRnML2Gw&location=37.754035,-122.447532&radius=50000"
URLBASE=$URLBASEORIG
echo "NEXT URL $URLBASE"
RESPONSE=$(curl "$URLBASE")
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)

sleep 3

URLBASE="$URLBASEORIG&pagetoken=$NEXTPAGE"
echo "NEXT URL $URLBASE"
RESPONSE=$(curl $URLBASE)
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)

sleep 3

URLBASE="$URLBASEORIG&pagetoken=$NEXTPAGE"
echo "NEXT URL $URLBASE"
RESPONSE=$(curl $URLBASE)
NEXTPAGE=$(echo $RESPONSE | jq '.next_page_token' | sed -E 's/"//g')
echo "NEXT PAGE $NEXTPAGE"
LOCS=$(echo $RESPONSE | jq '.results[].geometry.location|tostring' | sed -E 's/....lat...(.*),..lng...(.*)../\1,\2/g' >> sflocs.csv)
