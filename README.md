The intent of this project is to:

1. Provide a single-container [Druid](http://druid.io/) service for dev/testing
2. Expose Druid's HTTP endpoints
3. Expose [Tranquility](https://github.com/druid-io/tranquility)'s "Stream Push" HTTP endpoint

The container also runs [Apache ZooKeeper](http://zookeeper.apache.org/) internally.

Tranquility is started with the example "metrics" dimensionless datasource. To customize sources, modify the conf/tranquility/server.json file.

Build:
```
docker build -t druid .
```

Run:
```
docker run -d -p 8081:8081 -p 8082:8082 -p 8083:8083 -p 8084:8084 -p 8088:8088 -p 8090:8090 -p 8091:8091 -p 8200:8200 druid
```

The examples below use an index defined for [Yahoo's currency stream](http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json).

Publish data to Druid via Tranquility's [Streaming Ingest](http://druid.io/docs/latest/ingestion/stream-ingestion.html):
```
curl -X POST -H'Content-Type: application/json' --data-binary @data/metrics.json http://localhost:8200/v1/post/metrics
...
{"result":{"received":25,"sent":25}}
```

An example Apache NiFi flow that polls Yahoo's currency feed and publishes to Druid is available in resources/flow.xml.gz.

Tranquility's HTTP endpoint accepts only data with timestamps inside the current window. When posting data with timestamps outside that bound, Tranquility's response resembles:
```
{"result":{"received":25,"sent":0}}
```

To index a file (including data from outside the current window):
```
curl -X 'POST' -H 'Content-Type:application/json' -d @index-tasks/quotes.json localhost:8090/druid/indexer/v1/task
```

Issue a Query:
```
curl -X POST "http://localhost:8082/druid/v2/?pretty" -H 'content-type: application/json' -d @queries/1.json
[ {
  "version" : "v1",
  "timestamp" : "2010-01-01T00:00:00.000Z",
  "event" : {
    "server" : "www1.example.com",
    "value" : 6
  }
}, {
  "version" : "v1",
  "timestamp" : "2010-01-01T00:00:00.000Z",
  "event" : {
    "server" : "www2.example.com",
    "value" : 12
  }
}, {
  "version" : "v1",
  "timestamp" : "2010-01-01T00:00:00.000Z",
  "event" : {
    "server" : "www3.example.com",
    "value" : 12
  }
}
...
]
```

