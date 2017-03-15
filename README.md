The intent of this project is to:

1. Provide a single-container [Druid](http://druid.io/) service for dev/testing
2. Expose Druid's HTTP API endpoints
3. Expose [Tranquility](https://github.com/druid-io/tranquility)'s "Stream Push" HTTP API endpoint

The container also runs [Apache ZooKeeper](http://zookeeper.apache.org/) internally.

Tranquility is started with the example "metrics" dimensionless datasource. To customize sources, modify the conf/tranquility/server.json file.

Build:
```
docker build -t druid .
```

Run:
```
docker run -d -p 8081:8081 -p 8082:8082 -p 8090:8090 druid
```

Push Some Data:
```
curl -X POST -H'Content-Type: application/json' --data-binary @data/metrics.json http://localhost:8200/v1/post/metrics
...
{"result":{"received":25,"sent":25}}
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
