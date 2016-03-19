airports:
	cat airports.csv | while read line; do lat=$(echo $line | cut -d, -f7); lon=$(echo $line | cut -d, -f8); echo $lat $lon; curl "http://local.life360.com/v3/v3locations/testGetAddress/$lat/$lon"; done;
