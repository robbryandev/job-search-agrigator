cat ./config.json | xargs -0 curl -X POST http://localhost:2000/api/jobs -H 'Content-Type: application/json' -d > output.json
