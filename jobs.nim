import json
import "./config.nim"

let configJson = parseFile("./config.json")
let jobConfig = configJson.newConfig()

echo $jobConfig