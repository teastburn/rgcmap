package main

import (
	"encoding/json"
	"fmt"
	"github.com/alecthomas/kingpin"
	"github.com/gocql/gocql"
	gj "github.com/kpawlik/geojson"
	"github.com/matryer/try"
	"github.com/yvasiyarov/gorelic"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"
)

// db globals
var (
	session *gocql.Session
	cluster *gocql.ClusterConfig
)

// config options (cli)
var (
	dbHost          = kingpin.Flag("db_host", "Cx host").Short('d').Default("192.168.99.100").String()
	serverPort      = kingpin.Flag("port", "Port to listen on").Short('p').Default("8080").Int()
	defaultRowLimit = kingpin.Flag("default_row_limit", "Max limit of rows to return by default").Short('l').Default("150").Int()
	pointTTL = kingpin.Flag("ttl", "TTL in seconds of the life of a row").Short('t').Default("3600").Int()
	nrSuffix = kingpin.Flag("nr_suffix", "Suffix for New Relic reporting name").Short('n').Default("dev").String()
)

func main() {
	kingpin.Version("0.0.1")
	kingpin.Parse()

	dbInit(*dbHost)
	defer session.Close()

	agent := gorelic.NewAgent()
	agent.Verbose = true
	agent.NewrelicName = fmt.Sprintf("tristan-rgcmap-%s", *nrSuffix)
	agent.NewrelicLicense = "9552dfb472326d435476232c79fa3be9b53c67ac"
	agent.Run()

	// dynamic endpoints
	http.HandleFunc("/locswrite.json", write)
	http.HandleFunc("/locsread.json", read)
	http.HandleFunc("/locsread.jsonp", readJsonp)
	http.HandleFunc("/count", count)
	http.HandleFunc("/reset", reset)

	// serve static html
	fs := http.FileServer(http.Dir(fmt.Sprintf("%s/src/github.com/teastburn/rgcmap/static", os.Getenv("GOPATH"))))
	http.Handle("/static/", http.StripPrefix("/static/", fs))

	hostAndPort := fmt.Sprintf("0.0.0.0:%d", *serverPort)
	log.Printf("Running on %s", hostAndPort)
	err := http.ListenAndServe(hostAndPort, nil)
	if err != nil {
		log.Printf("Failed to bind host and port: %+v", err)
	}
}

func dbInit(host string) {
	var err error
	// connect to the cluster, retrying for 60s before quitting
	try.Do(func(attempts int) (bool, error) {
		cluster = gocql.NewCluster(host)
		session, err = cluster.CreateSession()
		if err != nil {
			time.Sleep(3 * time.Second)
		}
		return attempts < 20, err
	})

	if err != nil {
		log.Fatal("cx cluster connect failed", err)
	}

	if err := session.Query(`create keyspace if not exists ks with replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 }`).Exec(); err != nil {
		log.Fatalf("create keyspace failure: %+v", err)
	}

	cluster.Keyspace = "ks"
	session, err = cluster.CreateSession()

	if err := session.Query(`create table if not exists ks.rgc(id timeuuid, lat float, lon float, address text, PRIMARY KEY((lat), id)) WITH CLUSTERING ORDER BY (id DESC)`).Exec(); err != nil {
		log.Fatalf("create table failure: %+v", err)
	}

	// insert some rgcs
	//if err := session.Query(`INSERT INTO rgc (id, lat, lon, address) VALUES (?, ?, ?, ?)`,
	//	gocql.TimeUUID(), float32(32.145), float32(-1.145), "1231 Fake st, Springfield, OR").Exec(); err != nil {
	//	log.Fatal(err)
	//}
	//if err := session.Query(`INSERT INTO rgc (id, lat, lon, address) VALUES (?, ?, ?, ?)`,
	//	gocql.TimeUUID(), float32(32.145), float32(-1.145), "1232 Fake st, Springfield, OR").Exec(); err != nil {
	//	log.Fatal(err)
	//}
	//if err := session.Query(`INSERT INTO rgc (id, lat, lon, address) VALUES (?, ?, ?, ?)`,
	//	gocql.TimeUUID(), float32(32.145), float32(-1.145), "1233 Fake st, Springfield, OR").Exec(); err != nil {
	//	log.Fatal(err)
	//}
}

func read(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Access-Control-Allow-Origin", "*")
	res.Header().Set("Access-Control-Allow-Credentials", "true")
	//res.Header().Set("Access-Control-Expose-Headers", "FooBar")

	qs := req.URL.Query()
	limit, err := strconv.Atoi(qs.Get("limit"))
	if err != nil || limit < 1 || limit > 1000 {
		log.Printf("limit was weird: %+v, %+v", limit, err)
		limit = *defaultRowLimit
	}

	var id, address string
	var lat, lon float32
	//red := "#bc2200"
	//green := "#06e104"
	fc := gj.FeatureCollection{Type: "FeatureCollection"}

	iter := session.Query(`SELECT id, lat, lon, address FROM rgc LIMIT ?`, limit).Iter()

	for iter.Scan(&id, &lat, &lon, &address) {
		props := map[string]interface{}{"id": id, "address": address}
		//props := map[string]interface{}{"marker-color": "", "marker-size": "medium", "id": id, "address": address}
		//if address == "" {
		//	props["marker-color"] = red
		//} else {
		//	props["marker-color"] = green
		//}

		c := gj.Coordinate{gj.Coord(lat), gj.Coord(lon)}
		f := gj.NewFeature(gj.NewPoint(c), props, nil)
		fc.AddFeatures(f)
	}

	if fcstr, err := gj.Marshal(fc); err != nil {
		panic(err)
	} else {
		res.Write([]byte(fcstr))
	}

	if err := iter.Close(); err != nil {
		log.Fatalf("iteration closing failure: %+v", err)
	}
}

func readJsonp(res http.ResponseWriter, req *http.Request) {
	res.Write([]byte("eqfeed_callback("))
	read(res, req)
	res.Write([]byte(");"))
}

func reset(res http.ResponseWriter, req *http.Request) {
	if err := session.Query(`truncate table ks.rgc`).Exec(); err != nil {
		log.Fatalf("truncate table failure: %+v", err)
	}
}

func count(res http.ResponseWriter, req *http.Request) {
	var count int
	if err := session.Query(`select count(*) from ks.rgc LIMIT 1000000`).Scan(&count); err != nil {
		log.Fatalf("count failure: %+v", err)
	}
	res.Write([]byte(strconv.Itoa(count)))
}

type jsonBody struct {
	Lat     float32 `json:"lat"`
	Lon     float32 `json:"lon"`
	Address string  `json:"address"`
}

func write(res http.ResponseWriter, req *http.Request) {
	decoder := json.NewDecoder(req.Body)
	var jb jsonBody
	err := decoder.Decode(&jb)
	if err != nil {
		panic(err)
	}

	log.Printf("writing %+v", jb)
	if err := session.Query(`INSERT INTO rgc (id, lat, lon, address) VALUES (?, ?, ?, ?) USING TTL ?`,
		gocql.TimeUUID(), jb.Lat, jb.Lon, jb.Address, *pointTTL).Exec(); err != nil {
		log.Fatal(err)
	}
}
