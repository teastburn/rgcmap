HOST=$(shell docker-machine ip default)

airports:
	cat airports.csv | while read line; do lat=$(echo $line | cut -d, -f7); lon=$(echo $line | cut -d, -f8); echo $lat $lon; curl "http://local.life360.com/v3/v3locations/testGetAddress/$lat/$lon"; done;

sf:
	cat locs.csv | while read line; do lat=$(echo $line | cut -d, -f1); lon=$(echo $line | cut -d, -f2); echo $lat $lon; curl "http://local.life360.com/v3/v3locations/testGetAddress/$lat/$lon"; done;

cities:
	cat cities15000.txt | while read line; do ll=$(echo $line | grep -oE '\d+\.\d+\s+\d+\.\d+' | sed -E 's| |/|g'); echo $ll; curl "http://local.life360.com/v3/v3locations/testGetAddress/$ll"; done;

cities7k:
	cat world_cities_coords.csv | gshuf | while read line; do ll=$(echo $line | sed -E 's|,|/|g'); echo $ll; curl "http://local.life360.com/v3/v3locations/testGetAddress/$ll"; done

build:
	docker build --tag rgcmap_rgcmap:latest -f DockerfileDev .

up:
	docker-compose up

dr:
	docker stop rgcmap_rgcmap_1 || true
	docker rm rgcmap_rgcmap_1 || true
	docker rmi rgcmap_rgcmap:latest || true

rebuild: dr build

reup: rebuild up

write:
	curl $(HOST):8080/locswrite.json -d '{"lat":11.123,"lon":-11.123,"address":"123 fake st"}' -D -

read:
	curl -s $(HOST):8080/locsread.json?limit=2 | jq ''

count:
	curl $(HOST):8080/count -D -

reset:
	curl $(HOST):8080/reset

calls: write read count
