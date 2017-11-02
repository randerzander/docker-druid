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

**Batch Indexing Files**
To index a file (including data from outside the current window):
```
# Index product sales from a local CSV file
curl -X 'POST' -H 'Content-Type:application/json' -d @index-tasks/sales.csv localhost:8090/druid/indexer/v1/task

# Index BTC trades from a local JSON file
curl -X 'POST' -H 'Content-Type:application/json' -d @index-tasks/btc-trades.json localhost:8090/druid/indexer/v1/task
```

Issue a Druid JSON Query:
```
curl -X POST "http://localhost:8082/druid/v2/?pretty" -H 'content-type: application/json' -d @queries/btc-trades.json
[ {
  "version" : "v1",
  "timestamp" : "2017-11-02T01:35:00.000Z",
  "event" : {
    "priceMin" : 6877.0,
    "priceMax" : 6915.26,
    "priceRange" : 38.26000000000022
  }
}, {
  "version" : "v1",
  "timestamp" : "2017-11-02T01:40:00.000Z",
  "event" : {
    "priceMin" : 6833.5,
    "priceMax" : 6899.0,
    "priceRange" : 65.5
  }
...
]
```

**Publishing Streaming Data to Druid over HTTP**
To push data to Druid via Tranquility's [Streaming Ingest](http://druid.io/docs/latest/ingestion/stream-ingestion.html):
```
curl -X POST -H'Content-Type: application/json' --data-binary @data/btc-trades.json http://localhost:8200/v1/post/btc-trades_stream
...
{"result":{"received":25,"sent":25}}
```
*Note* data timestamps MUST be from within the last 5 minutes for the HTTP server to ingest them. If they are not, you'll see:
```
{"result":{"received":25,"sent":0}}
```

An example [Apache NiFi](http://nifi.apache.org/) flow that polls [BitStamp's bitcoin trade feed](https://www.bitstamp.net/api/transactions/) and publishes to Druid is available in resources/flow.xml.gz.

Issue a SQL query for raw Druid rows:
```
curl -XPOST -H'Content-Type: application/json' http://localhost:8082/druid/v2/sql/ --data-binary @queries/sql.json
[{"__time":"2017-11-02T05:25:08.000Z","amountMax":0.99691081,"amountMin":0.99691081,"amountSum":0,"count":1,"priceMax":6858.11,"priceMin":6858.11,"type":"0"},{"__time":"2017-11-02T05:25:08.000Z","amountMax":0.99691081,"amountMin":0.99691081,"amountSum":0,"count":1,"priceMax":6858.11,"priceMin":6858.11,"type":"0"}]
```

Sample Data Sources:
https://www.ibm.com/communities/analytics/watson-analytics-blog/sales-products-sample-data/
https://www.bitstamp.net/api/transactions/
