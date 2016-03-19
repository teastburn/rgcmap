package main

import (
	"github.com/gocql/gocql"
	"net/http"
	"log"
	gj "github.com/kpawlik/geojson"
	"encoding/json"
	"os"
	"fmt"
)

var (
	session *gocql.Session
)

func main() {
	// connect to the cluster
	cluster := gocql.NewCluster("life360-cassandra")
	var err error
	session, err = cluster.CreateSession()
	defer session.Close()
	if err != nil {
		log.Fatal("cluster connect failed 1", err)
	}

	if err := session.Query(`create keyspace if not exists ks with replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 }`).Exec(); err != nil {
		log.Fatal(err)
	}

	cluster.Keyspace = "ks"
	session, err = cluster.CreateSession()
	defer session.Close()
	if err != nil {
		log.Fatal("cluster connect failed 2", err)
	}

	if err := session.Query(`create table if not exists ks.rgc(id timeuuid, lat float, lon float, address text, PRIMARY KEY(id))`).Exec(); err != nil {
		log.Fatal(err)
	}

	// insert some rgcs
	if err := session.Query(`INSERT INTO rgc (id, lat, lon, address) VALUES (?, ?, ?, ?)`,
		gocql.TimeUUID(), float32(32.145), float32(-1.145), "1231 Fake st, Springfield, OR").Exec(); err != nil {
		log.Fatal(err)
	}
	if err := session.Query(`INSERT INTO rgc (id, lat, lon, address) VALUES (?, ?, ?, ?)`,
		gocql.TimeUUID(), float32(32.145), float32(-1.145), "1232 Fake st, Springfield, OR").Exec(); err != nil {
		log.Fatal(err)
	}
	if err := session.Query(`INSERT INTO rgc (id, lat, lon, address) VALUES (?, ?, ?, ?)`,
		gocql.TimeUUID(), float32(32.145), float32(-1.145), "1233 Fake st, Springfield, OR").Exec(); err != nil {
		log.Fatal(err)
	}


	log.Printf("Running on 0.0.0.0:8080")

	http.HandleFunc("/locswrite.json", write)
	http.HandleFunc("/locsread.json", read)
	http.HandleFunc("/test.html", func(res http.ResponseWriter, req *http.Request){
		http.ServeFile(res, req, fmt.Sprintf("%s/src/github.com/teastburn/rgcmap/static/test.html", os.Getenv("GOPATH")))
	})
	http.ListenAndServe("0.0.0.0:8080", nil)
}

func read(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Access-Control-Allow-Origin", "null")
	res.Header().Set("Access-Control-Allow-Credentials", "true")
	res.Header().Set("Access-Control-Expose-Headers", "FooBar")

	var id, address string
	var lat, lon float32
	red := "#bc2200"
	green := "#06e104"
	fc := gj.FeatureCollection{Type: "FeatureCollection"}

	iter := session.Query(`SELECT id, lat, lon, address FROM rgc LIMIT 100`).Iter();

	for iter.Scan(&id, &lat, &lon, &address) {
		log.Println(id, lat, lon, address)
		props := map[string]interface{}{"marker-color": "", "marker-size": "medium", "id": id, "address": address}
		if address != "" {
			props["marker-color"] = red
		} else {
			props["marker-color"] = green
		}

		c := gj.Coordinate{gj.Coord(lat), gj.Coord(lon)}
		p := gj.NewPoint(c)
		f := gj.NewFeature(p, props, nil)
		fc.AddFeatures(f)
	}

	if fcstr, err := gj.Marshal(fc); err != nil {
		panic(err)
	} else {
		res.Write([]byte(fcstr))
	}

	if err := iter.Close(); err != nil {
		log.Fatal(err)
	}
}

type jsonBody struct {
	Lat float32 `json:"lat"`
	Lon float32 `json:"lon"`
	Address string `json:"address"`
}

func write(res http.ResponseWriter, req *http.Request) {
	decoder := json.NewDecoder(req.Body)
	var jb jsonBody
	err := decoder.Decode(&jb)
	if err != nil {
		panic(err)
	}
	log.Printf("writing %+v", jb)
	if err := session.Query(`INSERT INTO rgc (id, lat, lon, address) VALUES (?, ?, ?, ?) USING TTL 86400`,
		gocql.TimeUUID(), jb.Lat, jb.Lon, jb.Address).Exec(); err != nil {
		log.Fatal(err)
	}
}
